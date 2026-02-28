module registers;

const char REGISTERS_NUM = 13;

alias Register = ulong;
alias Registers = ulong[REGISTERS_NUM];

fn char reg(ulong index) {
  return index >= REGISTERS_NUM ? REGISTERS_NUM - 1 : (char)index;
}
