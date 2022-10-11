pragma circom 2.0.0;

include "../../circuits/mux3.circom";
include "../../circuits/bitify.circom";


template Constants() {
    var i;
    signal output out[8];

    out[0] <== 37;
    out[1] <== 47;
    out[2] <== 53;
    out[3] <== 71;
    out[4] <== 89;
    out[5] <== 107;
    out[6] <== 163;
    out[7] <== 191;
}

template Main() {
    var i;
    signal input selector;//private
    signal output out;

    out <== Mux3()(Constants()(), Num2Bits(3)(selector));
}

component main = Main();
