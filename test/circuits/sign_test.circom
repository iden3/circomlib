pragma circom 2.1.5;

include "../../circuits/comparators.circom";
include "../../circuits/tags-managing.circom";
include "../../circuits/aliascheck.circom";

template A(){
    input signal in[254];
    component csign = Sign();
    csign.in <== AliasCheck()(BinaryCheckArray(254)(in));
    output signal {binary} sign <== csign.sign;

}

component main = A();
