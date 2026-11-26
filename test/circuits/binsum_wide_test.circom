pragma circom 2.1.5;

include "../../circuits/binsum.circom";
include "../../circuits/tags-managing.circom";

// Must not compile: the sum needs 253 bits and out could alias mod p.
template A(n, ops) {
    input signal in[ops][n];
    output signal out[nbits((2**n - 1) * ops)];

    signal {binary} bits[ops][n];
    for (var j = 0; j < ops; j++) {
        bits[j] <== BinaryCheckArray(n)(in[j]);
    }
    out <== BinSum(n, ops)(bits);
}

component main = A(252, 2);
