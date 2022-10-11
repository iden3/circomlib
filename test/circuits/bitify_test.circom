pragma circom 2.0.0;
include "../../circuits/bitify.circom";


template Main(n) {
    signal input in;
    signal output out[n];

    signal {binary} aux[n] <== Num2Bits(n)(in);
    signal {maxbit} aux2 <== Bits2Num(n)(aux);
    assert(aux2.maxbit == n);
    out <== aux;
    signal {maxbit} aux3 <== AddMaxbitTag(n)(in);
    assert(aux3.maxbit == aux2.maxbit);
    aux3 === aux2;
}

component main = Main(30);
