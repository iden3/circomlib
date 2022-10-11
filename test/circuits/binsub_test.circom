pragma circom 2.0.0;

include "../../circuits/bitify.circom";
include "../../circuits/binsub.circom";

template A() {
    signal input a; //private
    signal input b;
    signal output out;

    var i;


    signal {binary} aux[2][16];
    aux[0] <== Num2Bits(16)(a);
    aux[1] <== Num2Bits(16)(b);
    
    out <== Bits2Num(16)(BinSub(16)(aux));

}

component main = A();
