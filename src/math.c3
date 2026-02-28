module math;

fn char min(char a, char b) {
  return a < b ? a : b;
}

fn char max(char a, char b) {
  return a < b ? b : a;
}

<* Power that works on two positive numbers *>
fn uint pow(char x, char y) {
  if (y == 0) {
    return 1;
  }

  uint t = pow(x, y / 2);
  if ((y % 2) == 0) {
    return t * t;
  } else {
    return x * t * t;
  }
}
