pragma circom 2.0.0;

include "../../circuits/sha256/sha256.circom";
include "../../circuits/bitify.circom";

template Main(n) {
    signal input in[n];
    signal output out[256];
    out <== Sha256(n)(AddBinaryArrayTag(n)(in));
}

component main = Main(512);
