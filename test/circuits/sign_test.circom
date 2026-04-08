pragma circom 2.1.5;

include "../../circuits/comparators.circom";
include "../../circuits/tags-managing.circom";

template A(){
    input signal in[254];
    component sign = Sign();
    sign.in <== BinaryCheckArray(254)(in);
    output signal {binary} out <== sign.sign;

}

component main = A();
