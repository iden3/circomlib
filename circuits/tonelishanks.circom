include "comparators.circom";
include "pointbits.circom"


template ToneliShanks() {
  signal input in;
  signal output out;
  out <-- sqrt(in);
  out*out === in;
}

template isSquare() {
  signal input in;
  signal output out;

  signal p1;
  p1 <-- sqrt(in);

  signal p2;
  p2 <-- sqrt(5*in);

  signal r1;
  r1 <== p1*p1 - in;

  signal r2;
  r2 <== p2*p2 - 5*in;

  r1 * r2 === 0;
  component r1zero = IsZero();
  r1zero.in <== r1;
  out <== r1zero.out;
}

