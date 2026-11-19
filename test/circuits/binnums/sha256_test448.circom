pragma circom 2.1.5;

include "../../../circuits/binnums/sha256/sha256.circom";
include "../../../circuits/binnums/tags-managing.circom";


template Main() {
    input signal in[448]; //private
    output signal out[256];

    component sha256_2 = Sha256(448);

    sha256_2.in <== BinaryCheckArray(448)(in);
    out <== sha256_2.out.bits;
}

component main = Main();
