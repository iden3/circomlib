pragma circom 2.1.5;

include "../../circuits/sha256/sha256.circom";
include "../../circuits/tags-managing.circom";


template Main() {
    input signal in[512]; //private
    output signal out[256];

    component sha256_2 = Sha256(512);

    sha256_2.in <== BinaryCheckArray(512)(in);
    out <== sha256_2.out;
}

component main = Main();
