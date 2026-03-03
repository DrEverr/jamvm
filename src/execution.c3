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

fn void ExeResult.ok(&self) {
  self.result = Result.OK;
}

fn void ExeResult.panic(&self) {
  self.result = Result.STATUS;
  self.status = Status.PANIC;
}

fn void ExeResult.host(&self, int code) {
  self.result = Result.STATUS;
  self.status = Status.HOST;
  self.exitCode = code;
}

fn void ExeResult.page_fault(&self, int address) {
  self.result = Result.STATUS;
  self.status = Status.FAULT;
  self.exitCode = address;
}

fn void ExeResult.static_jump(&self, int offset) {
  self.result = Result.STATIC_JUMP;
  self.staticJump = offset;
}

fn void ExeResult.dynamic_jump(&self, int address) {
  self.result = Result.DYNAMIC_JUMP;
  self.dynamicJump = address;
}
