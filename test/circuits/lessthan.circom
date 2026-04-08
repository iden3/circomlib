pragma circom 2.1.5;

include "../../circuits/comparators.circom";
include "../../circuits/tags-managing.circom";


template A(n){
    input signal in[2];
    output signal out <== LessThan(n)(MaxbitCheckArray(n, 2)(in));

}

component main = A(30);
