pragma circom 2.1.5;

include "../../circuits/comparators.circom";
include "../../circuits/tags-managing.circom";

template A(){
    signal input in[254];
    signal output out <== Sign()(BinaryCheckArray(254)(in));

}

component main = A();
