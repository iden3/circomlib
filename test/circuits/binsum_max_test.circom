pragma circom 2.1.5;

include "../../circuits/binsum.circom";
include "../../circuits/tags-managing.circom";

// The widest BinSum with 4 operands: n + nbits(ops - 1) = 252.
template A(n, ops) {
    input signal in[ops][n];
    output signal out[nbits((2**n - 1) * ops)];

    signal {binary} bits[ops][n];
    for (var j = 0; j < ops; j++) {
        bits[j] <== BinaryCheckArray(n)(in[j]);
    }
    out <== BinSum(n, ops)(bits);
}

component main = A(250, 4);
