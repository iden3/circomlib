pragma circom 2.1.5;

include "../../../circuits/binnums/comparators.circom";
include "../../../circuits/binnums/tags-managing.circom";
include "../../../circuits/binnums/aliascheck.circom";

template A(){
    input signal in[254];
    component csign = Sign();
    csign.in <== AliasCheck()(BinaryCheckArray(254)(in));
    output signal {binary} sign <== csign.sign;

}

component main = A();
