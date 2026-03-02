module instructions;

import gas;
import args;

struct Instruction {
  String name;
  Args kind;
  Gas gas;
}

const Instruction MISSING = { "INVALID", Args.ZERO, 1 };






const Instruction[*] INSTRUCTIONS = {
  { "trap", Args.ZERO, 1 }, // 0
  { "fallthrough", Args.ZERO, 1 }, // 1
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  { "ecalli", Args.ONE_IMM, 1 }, // 10
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  { "load_ imm_64", Args.ONE_REG_ONE_EXT_IMM, 1 }, // 20
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  { "store_imm_u8", Args.TWO_IMM, 1 }, // 30
  { "store_imm_u16", Args.TWO_IMM, 1 }, // 31
  { "store_imm_u32", Args.TWO_IMM, 1 }, // 32
  { "store_imm_u64", Args.TWO_IMM, 1 }, // 32
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  { "jump", Args.ONE_OFF, 1 }, // 40
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  { "jump_ind", Args.ONE_REG_ONE_IMM, 1 }, // 50
  { "load_imm", Args.ONE_REG_ONE_IMM, 1 }, // 51
  { "load_u8", Args.ONE_REG_ONE_IMM, 1 }, // 52
  { "load_i8", Args.ONE_REG_ONE_IMM, 1 }, // 53
  { "load_u16", Args.ONE_REG_ONE_IMM, 1 }, // 54
  { "load_i16", Args.ONE_REG_ONE_IMM, 1 }, // 55
  { "load_u32", Args.ONE_REG_ONE_IMM, 1 }, // 56
  { "load_i32", Args.ONE_REG_ONE_IMM, 1 }, // 57
  { "load_u64", Args.ONE_REG_ONE_IMM, 1 }, // 58
  { "store_u8", Args.ONE_REG_ONE_IMM, 1 }, // 59
  { "store_u16", Args.ONE_REG_ONE_IMM, 1 }, // 60
  { "store_u32", Args.ONE_REG_ONE_IMM, 1 }, // 61
  { "store_u64", Args.ONE_REG_ONE_IMM, 1 }, // 62
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  { "store_imm_ind_u8", Args.ONE_REG_TWO_IMM, 1 }, // 70
  { "store_imm_ind_u16", Args.ONE_REG_TWO_IMM, 1 }, // 71
  { "store_imm_ind_u32", Args.ONE_REG_TWO_IMM, 1 }, // 72
  { "store_imm_ind_u64", Args.ONE_REG_TWO_IMM, 1 }, // 73
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  { "load_imm_jump", Args.ONE_REG_ONE_IMM_ONE_OFF, 1 }, // 80
  { "branch_eq_imm", Args.ONE_REG_ONE_IMM_ONE_OFF, 1 }, // 81
  { "branch_ne_imm", Args.ONE_REG_ONE_IMM_ONE_OFF, 1 }, // 82
  { "branch_lt_u_imm", Args.ONE_REG_ONE_IMM_ONE_OFF, 1 }, // 83
  { "branch_le_u_imm", Args.ONE_REG_ONE_IMM_ONE_OFF, 1 }, // 84
  { "branch_ge_u_imm", Args.ONE_REG_ONE_IMM_ONE_OFF, 1 }, // 85
  { "branch_gt_u_imm", Args.ONE_REG_ONE_IMM_ONE_OFF, 1 }, // 86
  { "branch_lt_s_imm", Args.ONE_REG_ONE_IMM_ONE_OFF, 1 }, // 87
  { "branch_le_s_imm", Args.ONE_REG_ONE_IMM_ONE_OFF, 1 }, // 88
  { "branch_ge_s_imm", Args.ONE_REG_ONE_IMM_ONE_OFF, 1 }, // 89
  { "branch_gt_s_imm", Args.ONE_REG_ONE_IMM_ONE_OFF, 1 }, // 90
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  { "move_reg", Args.TWO_REG, 1 }, // 100
  { "sbrk", Args.TWO_REG, 1 }, // 101
  { "count_set_bits_64", Args.TWO_REG, 1 }, // 102
  { "count_set_bits_32", Args.TWO_REG, 1 }, // 103
  { "leading_zero_bits_64", Args.TWO_REG, 1 }, // 104
  { "leading_zero_bits_32", Args.TWO_REG, 1 }, // 105
  { "trailing_zero_bits_64", Args.TWO_REG, 1 }, // 106
  { "trailing_zero_bits_32", Args.TWO_REG, 1 }, // 107
  { "sign_extend_8 ", Args.TWO_REG, 1 }, // 108
  { "sign_extend_16", Args.TWO_REG, 1 }, // 109
  { "zero_ extend_16", Args.TWO_REG, 1 }, // 110
  { "reverse_bytes", Args.TWO_REG, 1 }, // 111
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  { "store_ind_u8", Args.TWO_REG_ONE_IMM, 1 }, // 120
  { "store_ind_u16", Args.TWO_REG_ONE_IMM, 1 }, // 121
  { "store_ind_u32", Args.TWO_REG_ONE_IMM, 1 }, // 122
  { "store_ind_u64", Args.TWO_REG_ONE_IMM, 1 }, // 123
  { "load_ind_u8", Args.TWO_REG_ONE_IMM, 1 }, // 124
  { "load_ind_18", Args.TWO_REG_ONE_IMM, 1 }, // 125
  { "load_ind_u16", Args.TWO_REG_ONE_IMM, 1 }, // 126
  { "load_ind_i16", Args.TWO_REG_ONE_IMM, 1 }, // 127
  { "load_ind_u32", Args.TWO_REG_ONE_IMM, 1 }, // 128
  { "load_ind_i32", Args.TWO_REG_ONE_IMM, 1 }, // 129
  { "load_ind_u64", Args.TWO_REG_ONE_IMM, 1 }, // 130
  { "add_imm_32", Args.TWO_REG_ONE_IMM, 1 }, // 131
  { "and_imm", Args.TWO_REG_ONE_IMM, 1 }, // 132
  { "xor_imm", Args.TWO_REG_ONE_IMM, 1 }, // 133
  { "or_imm", Args.TWO_REG_ONE_IMM, 1 }, // 134
  { "mul_imm_32", Args.TWO_REG_ONE_IMM, 1 }, // 135
  { "set_lt_u_imm", Args.TWO_REG_ONE_IMM, 1 }, // 136
  { "set_lt_s_imm", Args.TWO_REG_ONE_IMM, 1 }, // 137
  { "shlo_l_imm_32", Args.TWO_REG_ONE_IMM, 1 }, // 138
  { "shlo_r_imm_32", Args.TWO_REG_ONE_IMM, 1 }, // 139
  { "shar_x_imm_32", Args.TWO_REG_ONE_IMM, 1 }, // 140
  { "neg_add_imm_32", Args.TWO_REG_ONE_IMM, 1 }, // 141
  { "set_gt_u_imm", Args.TWO_REG_ONE_IMM, 1 }, // 142
  { "set_gt_s_imm", Args.TWO_REG_ONE_IMM, 1 }, // 143
  { "shlo_l_imm_alt_32", Args.TWO_REG_ONE_IMM, 1 }, // 144
  { "shlo_r_imm_alt_32", Args.TWO_REG_ONE_IMM, 1 }, // 145
  { "shar_r_imm_alt_32", Args.TWO_REG_ONE_IMM, 1 }, // 146
  { "cmov_iz_imm", Args.TWO_REG_ONE_IMM, 1 }, // 147
  { "cmov_nz_imm", Args.TWO_REG_ONE_IMM, 1 }, // 148
  { "add_imm_64 ", Args.TWO_REG_ONE_IMM, 1 }, // 149
  { "mul_imm_64", Args.TWO_REG_ONE_IMM, 1 }, // 150
  { "shlo_l_imm_64 ", Args.TWO_REG_ONE_IMM, 1 }, // 151
  { "shlo_r_imm_64 ", Args.TWO_REG_ONE_IMM, 1 }, // 152
  { "shar_r_imm_64", Args.TWO_REG_ONE_IMM, 1 }, // 153
  { "neg_add_imm_64", Args.TWO_REG_ONE_IMM, 1 }, // 154
  { "shlo_l_imm_alt_64", Args.TWO_REG_ONE_IMM, 1 }, // 155
  { "shlo_r_imm_alt_64", Args.TWO_REG_ONE_IMM, 1 }, // 156
  { "shar_r_imm_alt_64", Args.TWO_REG_ONE_IMM, 1 }, // 157
  { "rot_x_64_imm", Args.TWO_REG_ONE_IMM, 1 }, // 158
  { "rot_r_64_imm_alt", Args.TWO_REG_ONE_IMM, 1 }, // 159
  { "rot_r_32_imm", Args.TWO_REG_ONE_IMM, 1 }, // 160
  { "rot_r_32_imm_alt", Args.TWO_REG_ONE_IMM, 1 }, // 161
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  { "branch_eq", Args.TWO_REG_ONE_OFF, 1 }, // 170
  { "branch_ne", Args.TWO_REG_ONE_OFF, 1 }, // 171
  { "branch_lt_u", Args.TWO_REG_ONE_OFF, 1 }, // 172
  { "branch_lt_s", Args.TWO_REG_ONE_OFF, 1 }, // 173
  { "branch_ge_u", Args.TWO_REG_ONE_OFF, 1 }, // 174
  { "branch_ge_s", Args.TWO_REG_ONE_OFF, 1 }, // 175
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  { "load_imm_jump_ind", Args.TWO_REG_TWO_IMM, 1 }, // 180
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  MISSING,
  { "add_32", Args.THREE_REG, 1 }, // 190
  { "sub_32", Args.THREE_REG, 1 }, // 191
  { "mul_32", Args.THREE_REG, 1 }, // 192
  { "div_u_32", Args.THREE_REG, 1 }, // 193
  { "div_s_32", Args.THREE_REG, 1 }, // 194
  { "rem_u_32", Args.THREE_REG, 1 }, // 195
  { "rem_s_32", Args.THREE_REG, 1 }, // 196
  { "shlo_l_32", Args.THREE_REG, 1 }, // 197
  { "shlo_r_32", Args.THREE_REG, 1 }, // 198
  { "shar_r_32", Args.THREE_REG, 1 }, // 199
  { "add_64", Args.THREE_REG, 1 }, // 200
  { "sub_64", Args.THREE_REG, 1 }, // 201
  { "mul_64", Args.THREE_REG, 1 }, // 202
  { "div_u_64", Args.THREE_REG, 1 }, // 203
  { "div_s_64", Args.THREE_REG, 1 }, // 204
  { "rem_u_64", Args.THREE_REG, 1 }, // 205
  { "rem_s_64", Args.THREE_REG, 1 }, // 206
  { "shlo_l_64", Args.THREE_REG, 1 }, // 207
  { "shlo_r_64", Args.THREE_REG, 1 }, // 208
  { "shar_r_64", Args.THREE_REG, 1 }, // 209
  { "and", Args.THREE_REG, 1 }, // 210
  { "xor", Args.THREE_REG, 1 }, // 211
  { "or", Args.THREE_REG, 1 }, // 212
  { "mul_upper_s_s", Args.THREE_REG, 1 }, // 213
  { "mul_upper_u_u", Args.THREE_REG, 1 }, // 214
  { "mul_upper_s_u", Args.THREE_REG, 1 }, // 215
  { "set_lt_u", Args.THREE_REG, 1 }, // 216
  { "set_lt_s", Args.THREE_REG, 1 }, // 217
  { "cmov_iz", Args.THREE_REG, 1 }, // 218
  { "cmov_nz", Args.THREE_REG, 1 }, // 219
  { "rot_l_64", Args.THREE_REG, 1 }, // 220
  { "rot_l_32", Args.THREE_REG, 1 }, // 221
  { "rot_r_64", Args.THREE_REG, 1 }, // 222
  { "rot_r_32", Args.THREE_REG, 1 }, // 223
  { "and_inv", Args.THREE_REG, 1 }, // 224
  { "or_inv", Args.THREE_REG, 1 }, // 225
  { "xnor", Args.THREE_REG, 1 }, // 226
  { "max", Args.THREE_REG, 1 }, // 227
  { "max_u", Args.THREE_REG, 1 }, // 228
  { "min", Args.THREE_REG, 1 }, // 229
  { "min_u", Args.THREE_REG, 1 }, // 230
};

fn Instruction get_instruction(uint i) {
  if (i > INSTRUCTIONS.len) return MISSING;
  return INSTRUCTIONS[i];
}
