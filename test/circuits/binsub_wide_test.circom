pragma circom 2.1.5;

include "../../circuits/binsub.circom";
include "../../circuits/tags-managing.circom";

// Must not compile: out and aux could take a second decomposition mod p.
template A(n) {
    input signal in[2][n];
    output signal out[n];

    signal {binary} bits[2][n];
    bits[0] <== BinaryCheckArray(n)(in[0]);
    bits[1] <== BinaryCheckArray(n)(in[1]);
    out <== BinSub(n)(bits);
}

component main = A(253);
