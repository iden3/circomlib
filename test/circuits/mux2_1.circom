pragma circom 2.0.0;

include "../../circuits/mux2.circom";
include "../../circuits/bitify.circom";


template Constants() {
    var i;
    signal output out[4];

    out[0] <== 37;
    out[1] <== 47;
    out[2] <== 53;
    out[3] <== 71;
}

template Main() {
    var i;
    signal input selector;//private
    signal output out;

    out <== Mux2()(Constants()(), Num2Bits(2)(selector));
}

component main = Main();
