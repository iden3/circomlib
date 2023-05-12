pragma circom 2.1.5;

include "../../circuits/comparators.circom";
include "../../circuits/tags-managing.circom";


template A(n){
    signal input in[2];
    signal output out <== LessEqThan(n)(AddMaxbitArrayTag(n, 2)(in));

}

component main = A(30);
