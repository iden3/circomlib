pragma circom 2.0.0;

include "../../circuits/sign.circom";
include "../../circuits/bitify.circom";

template Main() {
    signal input in[254];
    signal output sign;
    
    sign <== Sign()(AddBinaryArrayTag(254)(in));
}

component main = Main();
