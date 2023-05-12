pragma circom 2.0.0;

include "../../circuits/sha256/sha256.circom";
include "../../circuits/tags-managing.circom";


template Main() {
    signal input a[448]; //private
    signal output out[256];

    component sha256_2 = Sha256(448);

    sha256_2.in <== AddBinaryArrayTag(448)(a);
    out <== sha256_2.out;
}

component main = Main();
