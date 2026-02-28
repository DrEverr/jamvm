module utils;

import types;

<*
  Change unsigned value to a signed version
  @param a: `Number to convert`
  @param n: `Number of bytes`
*>
fn long unsigned_to_signed(ulong a, int n) {
  ulong limit = pow_2_8n_min_1(n);
  return a < limit ? (long) a : (long) a - pow_2_8n(n);
}

<*
  Change signed value to a unsigned version
  @param a: `Number to convert`
  @param n: `Number of bytes`
*>
fn ulong signed_to_unsigned(long a, int n) {
  ulong mod_val = pow_2_8n(n);
  return ((ulong) a + mod_val) % mod_val;
}

fn ulong pow_2_8n(int n) @private {
  return (ulong) 1 << (8 * n);
}

fn ulong pow_2_8n_min_1(int n) @private {
  return (ulong) 1 << (8 * n - 1);
}
