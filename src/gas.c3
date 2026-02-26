module gas;

alias Gas = ulong;

struct GasCounter {
  Gas gas;
}

fn GasCounter init_gas_counter(Gas g) {
  return { g };
}

fn Gas GasCounter.get(GasCounter* gc) {
  return gc.gas;
}

fn bool GasCounter.sub(GasCounter* gc, Gas cost) {
  if (cost > gc.gas) {
    gc.gas = 0;
    return false;
  }
  gc.gas -= cost;
  return true;
}
