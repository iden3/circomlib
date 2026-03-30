pragma circom 2.1.5;

include "../../circuits/comparators.circom";
include "../../circuits/tags-managing.circom";

template A(){
    signal input in[254];
    signal output sign <== Sign()(BinaryCheckArray(254)(in));

}

component main = A();
