module registers;

const uint REGISTERS_NUM = 13;

alias Register = ulong;
alias Registers = ulong[REGISTERS_NUM];

fn uint reg(ulong index) {
  return index >= REGISTERS_NUM ? REGISTERS_NUM - 1 : (uint)index;
}
