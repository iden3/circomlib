pragma circom 2.0.0;

include "../../circuits/sha256/sha256.circom";
include "../../circuits/tags-managing.circom";


template Main() {
    signal input a[512]; //private
    signal output out[256];

    component sha256_2 = Sha256(512);

    sha256_2.in <== AddBinaryArrayTag(512)(a);
    out <== sha256_2.out;
}

component main = Main();
