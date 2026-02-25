module codec_test;

import codec;

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
  codec::Decoder dec = codec::new_decoder({0x00, 0x01, 0x7F, 0x80, 0x01, 0xC0, 0x00, 0x01, 0xE0, 0x00, 0x00, 0x01});
  test::eq(dec.var_u32()!!, 0);
  test::eq(dec.var_u32()!!, 1);
  test::eq(dec.var_u32()!!, 127);
  test::eq(dec.var_u32()!!, 1);
  test::eq(dec.var_u32()!!, 256);
  test::eq(dec.var_u32()!!, 65536);
}
