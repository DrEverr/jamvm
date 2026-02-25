module codec;

import std::math;
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
  uint len = var_len((char)result);
  if (len == 0) {
    dec.offset++;
    return result;
  }
  assert_enough(dec, len)!;
  result = (result + (uint)math::pow(2, (8 - len)) - (uint)math::pow(2, 8)) << (len * 8);
  uint v;
  for (int i = len - 1; i >= 0; i--) {
    v = (v << 8) + dec.data[dec.offset + 1 + (uint)i];
  }
  result += v;
  dec.offset += len + 1;
  return result;
}

fn Bytes? Decoder.bytes(Decoder* dec, uint len) {
  assert_enough(dec, len)!;
  Bytes v = dec.data[dec.offset..dec.offset + len];
  dec.offset += len;
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

fn char var_len(char byte) @private {
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
