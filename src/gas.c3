module gas;

alias Gas = ulong;

struct GasCounter {
  Gas gas;
}

fn GasCounter init_gas_counter(Gas g) {
  return { g };
}

fn Gas GasCounter.get(&self) {
  return self.gas;
}

fn bool GasCounter.sub(&self, Gas cost) {
  if (cost > self.gas) {
    self.gas = 0;
    return false;
  }
  self.gas -= cost;
  return true;
}
