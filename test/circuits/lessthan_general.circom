pragma circom 2.0.0;

include "../../circuits/comparators.circom";
include "../../circuits/bitify.circom";


template Main(n) {
    signal input in[2];
    signal output {binary} out;

    out <== LessThan_general()(AddMaxbitArrayTag(n,2)(in));
}

//component main = Main(32);
component main = Main(252);
//component main = Main(253);
