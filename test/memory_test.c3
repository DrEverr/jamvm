module memory_test;

import memory;

fn void test_page_access() @test {
  Page p = { .access = Access.NONE };
  test::eq(p.can_read(), false);
  test::eq(p.can_write(), false);

  p.access = Access.READ;
  test::eq(p.can_read(), true);
  test::eq(p.can_write(), false);

  p.access = Access.WRITE;
  test::eq(p.can_read(), true);
  test::eq(p.can_write(), true);
}

fn void test_pool_acquire_release_reuse() @test {
  Pool pool;
  pool.init(2);
  defer pool.clean_pool();

  test::eq(pool.allocated() >= 2, true);
  test::eq(pool.in_use(), 0);

  Page* p1 = pool.acquire(Access.WRITE);
  Page* p2 = pool.acquire(Access.READ);
  test::eq(pool.in_use(), 2);
  test::eq(p1.can_write(), true);
  test::eq(p1.can_read(), true);
  test::eq(p2.can_write(), false);
  test::eq(p2.can_read(), true);

  // Exceed initial capacity to verify dynamic growth path.
  Page* p_extra = pool.acquire(Access.READ);
  test::eq(pool.in_use(), 3);
  test::eq(pool.allocated() >= 3, true);
  pool.release(p_extra);
  test::eq(pool.in_use(), 2);

  p1.data[0] = 0x2A;
  pool.release(p1);
  test::eq(pool.in_use(), 1);

  Page* p3 = pool.acquire();
  test::eq(pool.in_use(), 2);
  test::eq(p3.data[0], 0);
}
