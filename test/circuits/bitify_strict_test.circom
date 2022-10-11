pragma circom 2.0.0;
include "../../circuits/bitify.circom";


template Main() {
    signal input in;
    signal output out[254];

    signal {binary} aux[254] <== Num2Bits_strict()(in);
    out <== aux;

    signal {binary} aux1[254] <== Num2Bits(254)(in);
    aux === aux1;    
    signal {maxbit} aux2 <== Bits2Num_strict()(aux1);
    assert(aux2.maxbit == 254);
    in === aux2;
}

component main = Main();
