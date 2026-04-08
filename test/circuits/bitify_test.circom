pragma circom 2.1.5;
include "../../circuits/bitify.circom";

template Main(n) {
    signal input in;

    signal {binary} aux[n] <== Num2Bits(n)(in);
    signal {maxbit} aux2 <== Bits2Num(n)(aux);
    assert(aux2.maxbit == n);
    in === aux2;
}

component main = Main(30);
