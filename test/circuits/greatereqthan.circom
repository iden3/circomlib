pragma circom 2.2.0;

include "../../circuits/comparators.circom";
include "../../circuits/tags-managing.circom";


template A(n){
    input signal in[2];
    output signal out <== GreaterEqThan(n)(MaxbitCheckArray(n, 2)(in));

}

component main = A(30);
