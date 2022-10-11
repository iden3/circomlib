pragma circom 2.0.0;

include "../../circuits/pointbits.circom";


template Main() {
    signal input in[2];

    signal auxout[2] <== Bits2Point_Strict()(Point2Bits_Strict()(in));
    auxout === in;
}

component main = Main();
