pragma circom 2.0.0;

include "../../circuits/comparators.circom";

template Main(n) {
    signal input in[2];
    signal output out;
    out <== GreaterEqThan(n)(AddMaxbitArrayTag(n,2)(in));
}

component main = Main(32);

