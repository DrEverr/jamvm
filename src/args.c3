module args;

import types;
import registers;
import math;
import utils;

alias ArgsType = ulong[<4>];
alias ArgsDecoder = fn ArgsType (Bytes code, uint offset = 0, char length = 0);

enum Args: char {
  ZERO,
  ONE_IMM,
  ONE_REG_ONE_EXT_IMM,
  TWO_IMM,
  ONE_OFF,
  ONE_REG_ONE_IMM,
  ONE_REG_TWO_IMM,
  ONE_REG_ONE_IMM_ONE_OFF,
  TWO_REG,
  TWO_REG_ONE_IMM,
  TWO_REG_ONE_OFF,
  TWO_REG_TWO_IMM,
  THREE_REG,
}

// const char[*] ARGS_COUNT    = { 0, 1, 2, 2, 1, 2, 3, 3, 2, 3, 3, 4, 3 };
// const char[*] ARGS_MIN_SIZE = { 0, 1, 9, 2, 1, 2, 2, 2, 2, 1, 2, 3, 2 };

<* Order same as in Args *>
const ArgsDecoder[*] DECODER = {
  // Args.ZERO
  fn (_c, _o, _l) => { 0, 0, 0, 0 },
  // Args.ONE_IMM
  fn (c, o, l) => { i64(c, o + 1, math::min(4, l)), 0, 0, 0 },
  // Args.ONE_REG_ONE_EXT_IMM
  fn (c, o, _l) => { registers::reg(lower(c[o + 1])), u64(c, o + 2, 8), 0, 0 },
  // Args.TWO_IMM,
  fn (c, o, l) {
    char lx = math::min(4, c[o + 1] & 0x7);
    char ly = math::min(4, math::max(0, l - lx - 1));
    return { i64(c, o + 2, lx), i64(c, o + 2 + lx, ly), 0, 0 };
  },
  // Args.ONE_OFF
  fn (c, o, l) {
    char lx = math::min(4, l);
    return { utils::unsigned_to_signed(i64(c, o + 1, lx), lx), 0, 0, 0};
  },
  // Args.ONE_REG_ONE_IMM
  fn (c, o, l) => { registers::reg(lower(c[o + 1])), i64(c, o + 2, math::min(4, math::max(0, l - 1))), 0, 0 },
  // Args.ONE_REG_TWO_IMM
  fn (c, o, l) {
    char lx = math::min(4, upper(c[o + 1]) & 0x7);
    char ly = math::min(4, math::max(0, l - lx - 1));
    return { registers::reg(lower(c[o + 1])), i64(c, o + 2, lx), i64(c, o + 2 + lx, ly), 0 };
  },
  // Args.ONE_REG_ONE_IMM_ONE_OFF
  fn (c, o, l) {
    char lx = math::min(4, upper(c[o + 1]) & 0x7);
    char ly = math::min(4, math::max(0, l - lx - 1));
    return { registers::reg(lower(c[o + 1])), i64(c, o + 2, lx), utils::unsigned_to_signed(i64(c, o + 2 + lx, ly), ly - lx), 0 };
  },
  // Args.TWO_REG
  fn (c, o, _l) => { registers::reg(lower(c[o + 1])), registers::reg(upper(c[o + 1])), 0, 0 },
  // Args.TWO_REG_ONE_IMM
  fn (c, o, l) => { registers::reg(lower(c[o + 1])), registers::reg(upper(c[o + 1])), i64(c, o + 2, math::min(4, math::max(0, l - 1))), 0 },
  // Args.TWO_REG_ONE_OFF
  fn (c, o, l) {
    char lx = math::min(4, math::max(0, l - 1));
    return { registers::reg(lower(c[o + 1])), registers::reg(upper(c[o + 1])), utils::unsigned_to_signed(i64(c, o + 2, lx), lx), 0 };
  },
  // Args.TWO_REG_TWO_IMM
  fn (c, o, l) {
    char lx = math::min(4, c[o + 2] & 0x7);
    char ly = math::min(4, math::max(0, l - lx - 2));
    return { registers::reg(lower(c[o + 1])), registers::reg(upper(c[o + 1])), i64(c, o + 3, lx), i64(c, o + 3 + lx, ly) };
  },
  // Args.THREE_REG
  fn (c, o, l) => { registers::reg(lower(c[o + 1])), registers::reg(upper(c[o + 1])), registers::reg(c[o + 2]), 0},
};

fn ulong i64(Bytes data, uint offset, char length) @private {
  if (length == 0) return 0;
  ulong v;
  for (int i; i < length; i++) {
    v |= (ulong)data[offset + i] << (i * 8);
  }
  if (length < 8 && data[offset + length - 1] & 0x80) {
    v |= (ulong)0x8000_0000 << (length * 8);
  }
  return v;
}

fn ulong u64(Bytes code, uint offset, int length) @private {
  if (length == 0) return 0;
  ulong v = code[offset];
  if (length == 1) return v;
  v |= (ulong)code[offset + 1] << 8;
  if (length == 2) return v;
  v |= (ulong)code[offset + 2] << 16;
  if (length == 3) return v;
  v |= (ulong)code[offset + 3] << 24;
  if (length == 4) return v;
  v |= (ulong)code[offset + 4] << 32;
  if (length == 5) return v;
  v |= (ulong)code[offset + 5] << 40;
  if (length == 6) return v;
  v |= (ulong)code[offset + 6] << 48;
  if (length == 7) return v;
  v |= (ulong)code[offset + 7] << 56;
  return v;
}

fn char upper(char v) @private {
  return (ulong)v >> 4;
}

fn char lower(char v) @private {
  return v & 0xF;
}

