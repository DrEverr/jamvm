module types;

alias Byte = char;
alias Bytes = Byte[];

enum Status : char
{
  HALT,
  PANIC,
  FAULT,
  HOST,
  OOG,
  OK,
}
