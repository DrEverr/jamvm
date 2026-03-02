module exe;

enum Result {
  OK,
  STATIC_JUMP,
  DYNAMIC_JUMP,
  STATUS,
}

enum Status {
  PANIC,
  FAULT,
  HOST,
}

struct ExeResult {
  Result result;
  Status status;
  int staticJump;
  uint dynamicJump;
  int exitCode;
}

fn void ExeResult.ok(ExeResult* exe) {
  exe.result = Result.OK;
}

fn void ExeResult.panic(ExeResult* exe) {
  exe.result = Result.STATUS;
  exe.status = Status.PANIC;
}

fn void ExeResult.host(ExeResult* exe, int code) {
  exe.result = Result.STATUS;
  exe.status = Status.HOST;
  exe.exitCode = code;
}

fn void ExeResult.fault(ExeResult* exe, int address) {
  exe.result = Result.STATUS;
  exe.status = Status.FAULT;
  exe.exitCode = code;
}

fn void ExeResult.static_jump(ExeResult* exe, int offset) {
  exe.result = Result.STATIC_JUMP;
  exe.staticJump = offset;
}

fn void ExeResult.dynamic_jump(ExeResult* exe, int address) {
  exe.result = Result.DYNAMIC_JUMP;
  exe.dynamicJump = address;
}
