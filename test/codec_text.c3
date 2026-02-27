module codec_test;

import codec;
import types;

fn void test_u8() @test {
  codec::Decoder dec = codec::new_decoder({1, 2, 3, 4, 5, 6, 7, 8});
  test::eq(dec.u8()!!, 1);
  test::eq(dec.u8()!!, 2);
  test::eq(dec.u8()!!, 3);
  test::eq(dec.u8()!!, 4);
  test::eq(dec.u8()!!, 5);
  test::eq(dec.u8()!!, 6);
  test::eq(dec.u8()!!, 7);
  test::eq(dec.u8()!!, 8);
}

fn void test_u16() @test {
  codec::Decoder dec = codec::new_decoder({1, 0, 0, 1, 1, 1, 1, 2});
  test::eq(dec.u16()!!, 1);
  test::eq(dec.u16()!!, 256);
  test::eq(dec.u16()!!, 257);
  test::eq(dec.u16()!!, 513);
}

fn void test_u24() @test {
  codec::Decoder dec = codec::new_decoder({1, 0, 0, 0, 1, 0, 0, 0, 1});
  test::eq(dec.u24()!!, 1);
  test::eq(dec.u24()!!, 256);
  test::eq(dec.u24()!!, 65536);
}

fn void test_u32() @test {
  codec::Decoder dec = codec::new_decoder({1, 0, 0, 0, 0, 0, 0, 1});
  test::eq(dec.u32()!!, 1);
  test::eq(dec.u32()!!, 16777216);
}

fn void test_var_u32() @test {
  codec::Decoder dec = codec::new_decoder({0x00, 0x01, 0x7F, 0x80, 0x01, 0xC0, 0x00, 0x01, 0xE0, 0x00, 0x00, 0x01, 0xF0, 0x00, 0x00, 0x00, 0x01 });
  test::eq(dec.var_u32()!!, 0);
  test::eq(dec.var_u32()!!, 1);
  test::eq(dec.var_u32()!!, 127);
  test::eq(dec.var_u32()!!, 1);
  test::eq(dec.var_u32()!!, 256);
  test::eq(dec.var_u32()!!, 65536);
  test::eq(dec.var_u32()!!, 16777216);
}

fn void test_u64() @test {
  codec::Decoder dec = codec::new_decoder({ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1});
  test::eq(dec.u64()!!, 1);
  test::eq(dec.u64()!!, 72057594037927936);
}

fn void test_var_u64() @test {
  codec::Decoder dec = codec::new_decoder({0x00, 0x01, 0x7F, 0x80, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 });
  test::eq(dec.var_u64()!!, 0);
  test::eq(dec.var_u64()!!, 1);
  test::eq(dec.var_u64()!!, 127);
  test::eq(dec.var_u64()!!, 255);
  test::eq(dec.var_u64()!!, 72057594037927936);
}

fn void test_encode() @test {
  types::Bytes b = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
  test::eq(codec::encode(0, b), 1);
  test::eq(b[..0], (types::Bytes){ 0 });
  test::eq(codec::encode(1, b), 1);
  test::eq(b[..0], (types::Bytes){ 0x01 });
  test::eq(codec::encode(127, b), 1);
  test::eq(b[..0], (types::Bytes){ 0x7F });
  test::eq(codec::encode(127, b[1..]), 1);
  test::eq(b[1..1], (types::Bytes){ 0x7F });
  test::eq(codec::encode(128, b), 2);
  test::eq(b[..1], (types::Bytes){ 0x80, 0x80 });
  test::eq(codec::encode(72057594037927936, b), 9);
  test::eq(b[..8], (types::Bytes){ 0xFF, 0, 0, 0, 0, 0, 0, 0, 0x01 });
}

fn void test_decode_encode() @test {
  codec::Decoder dec = codec::new_decoder({0x00, 0x01, 0x7F, 0x80, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01 });
  types::Bytes out = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
  int prev_off;
  while (!dec.is_done()) {
    int v = codec::encode(dec.var_u64()!!, out);
    test::eq(v, dec.offset - prev_off);
    test::eq(out[..v-1], dec.data[prev_off..prev_off+v-1]);
    prev_off = dec.offset;
  }
}
