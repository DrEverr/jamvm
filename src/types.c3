module types;

alias Bytes = char[];

enum Status : char
{
  HALT,
  PANIC,
  FAULT,
  HOST,
  OOG,
  OK,
}
