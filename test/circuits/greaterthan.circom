pragma circom 2.0.0;

include "../../circuits/comparators.circom";

template Main(n) {
    signal input in[2];
    signal output {binary} out;
    out <== GreaterThan(32)(AddMaxbitArrayTag(32,2)(in));
}

component main = Main(32);

