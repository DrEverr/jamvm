module gas_test;

import gas;

fn void test_gas_counter() @test {
  gas::GasCounter gc = gas::init_gas_counter(1000);
  test::eq(gc.get(), 1000);
  test::eq(gc.sub(500), true);
  test::eq(gc.get(), 500);
  test::eq(gc.sub(1000), false);
  test::eq(gc.get(), 0);
}
