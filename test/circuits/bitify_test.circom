pragma circom 2.1.5;
include "../../circuits/bitify.circom";

template Main(n) {
    signal input in;

    signal {binary} aux[n] <== Num2Bits(n)(in);
    signal {maxbit} aux2 <== Bits2Num(n)(aux);
    assert(aux2.maxbit == n);
    in === aux2;

    // Exposed so the decomposition itself can be checked, not only the fact
    // that Num2Bits and Bits2Num undo each other.
    output signal {binary} out[n] <== aux;
}

component main = Main(30);
