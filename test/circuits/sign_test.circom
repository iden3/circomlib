pragma circom 2.0.0;

include "../../circuits/sign.circom";
include "../../circuits/tags-managing.circom";

template A(){
    signal input in[254];
    signal output out <== Sign()(AddBinaryArrayTag(254)(in));

}

component main = A();
