module registers_test;

import registers;

fn void test_reg_clamp() @test {
  test::eq(registers::reg(0), 0);
  test::eq(registers::reg(1), 1);
  test::eq(registers::reg(10), 10);
  test::eq(registers::reg(12), 12);
  test::eq(registers::reg(16), 12);
  test::eq(registers::reg(120394), 12);
}
