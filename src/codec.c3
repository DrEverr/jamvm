module codec;

import math;

import types;

faultdef NOT_ENOUGH_BYTES;

const char[8] MASK = { 0xFF, 0xFE, 0xFC, 0xF8, 0xF0, 0xE0, 0xC0, 0x80 };

struct Decoder {
  uint offset;
  types::Bytes data;
}

fn Decoder new_decoder(types::Bytes data) {
  return { 0, data };
}

fn char? Decoder.u8(Decoder* dec) {
  assert_enough(dec, 1)!;
  return dec.data[dec.offset++];
}

fn ushort? Decoder.u16(Decoder* dec) {
  assert_enough(dec, 2)!;
  ushort result = dec.data[dec.offset];
  result |= dec.data[dec.offset + 1] << 8;
  dec.offset += 2;
  return result;
}

fn uint? Decoder.u24(Decoder* dec) {
  assert_enough(dec, 3)!;
  uint result = dec.data[dec.offset];
  result |= dec.data[dec.offset + 1] << 8;
  result |= dec.data[dec.offset + 2] << 16;
  dec.offset += 3;
  return result;
}

fn uint? Decoder.u32(Decoder* dec) {
  assert_enough(dec, 4)!;
  uint result = dec.data[dec.offset];
  result |= dec.data[dec.offset + 1] << 8;
  result |= dec.data[dec.offset + 2] << 16;
  result |= dec.data[dec.offset + 3] << 24;
  dec.offset += 4;
  return result;
}

fn uint? Decoder.var_u32(Decoder* dec) {
  assert_enough(dec, 1)!;
  uint result = dec.data[dec.offset];
  char length = var_length((char)result);
  if (length == 0) {
    dec.offset++;
    return result;
  }
  assert_enough(dec, length)!;
  result = length >= 4 ? 0 : (result + math::pow(2, (8 - length)) - math::pow(2, 8)) << (length * 8);
  uint v;
  for (int i = length - 1; i >= 0; i--) {
    v = (v << 8) + dec.data[dec.offset + 1 + (uint)i];
  }
  result += v;
  dec.offset += length + 1;
  return result;
}

fn ulong? Decoder.u64(Decoder* dec) {
  assert_enough(dec, 8)!;
  ulong result = (ulong)dec.data[dec.offset];
  result |= (ulong)dec.data[dec.offset + 1] << 8;
  result |= (ulong)dec.data[dec.offset + 2] << 16;
  result |= (ulong)dec.data[dec.offset + 3] << 24;
  result |= (ulong)dec.data[dec.offset + 4] << 32;
  result |= (ulong)dec.data[dec.offset + 5] << 40;
  result |= (ulong)dec.data[dec.offset + 6] << 48;
  result |= (ulong)dec.data[dec.offset + 7] << 56;
  dec.offset += 8;
  return result;
}

fn ulong? Decoder.var_u64(Decoder* dec) {
  assert_enough(dec, 1)!;
  ulong result = (ulong)dec.data[dec.offset];
  char length = var_length((char)result);
  if (length == 0) {
    dec.offset++;
    return result;
  }
  assert_enough(dec, length)!;
  result = length == 8 ? 0 : (result + math::pow(2, (8 - length)) - math::pow(2, 8)) << (length * 8);
  ulong v;
  for (int i = length - 1; i >= 0; i--) {
    v = (v << 8) + (ulong)dec.data[dec.offset + 1 + (uint)i];
  }
  result += v;
  dec.offset += length + 1;
  return result;
}

fn Bytes? Decoder.bytes(Decoder* dec, uint length) {
  assert_enough(dec, length)!;
  Bytes v = dec.data[dec.offset..dec.offset + length];
  dec.offset += length;
  return v;
}

<* Read till the end. *>
fn Bytes Decoder.rest(Decoder* dec) {
  Bytes v = dec.data[dec.offset..];
  dec.offset += v.len;
  return v;
}

fn bool Decoder.is_done(Decoder* dec) {
  return dec.offset >= dec.data.len;
}

<*
 Encode natural number to var_u64.

 @param a: `The natural number to encode.`
 @param out: `Output buffer.`
 @require out.len >= 9
 @return `Number of bytes written.`
*>
fn int encode(ulong a, types::Bytes out) {
  if (a == 0) {
    out[0] = (char)0;
    return 1;
  }

  int l = 0;
  while (l <= 7 && a >= (1UL << (7 * (l + 1)))) l++;

  if (l == 8) {
    out[0] = (char)0xFF;
    encode_le(a, 8, out[1..]);
    return 9;
  }

  out[0] = (char)(0xFF << (8 - l)) | (char)(a >> (8 * l));
  encode_le(a, l, out[1..]);
  return l + 1;
}

<*
 Encode a 64-bit unsigned integer as little-endian bytes.

 @param a: `The value to encode.`
 @param n: `Number of bytes to write.`
 @param out: `Output buffer to write into.`
 @require n >= 0, n <= 8
*>
fn void encode_le(ulong a, int n, types::Bytes out) @private {
  for (int i; i < n; i++) {
    out[i] = (char)((a >> (8 * i)) & 0xFF);
  }
}

fn char var_length(char byte) @private {
  foreach (i, v : MASK) {
    if (byte >= v) {
      return 8 - (char)i;
    }
  }
  return 0;
}

fn void? assert_enough(Decoder* dec, uint bytes) @private {
  if ((ulong)dec.offset + bytes > dec.data.len) {
    return NOT_ENOUGH_BYTES~;
  }
}
