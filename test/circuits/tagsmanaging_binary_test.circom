pragma circom 2.1.5;

include "../../circuits/tags-managing.circom";

// BinaryCheck and BinaryCheckArray: constrain the inputs to be binary and
// hand back the same values carrying the binary tag.

template A(n){
    input signal in;
    input signal ina[n];

    output signal {binary} out <== BinaryCheck()(in);
    output signal {binary} outa[n] <== BinaryCheckArray(n)(ina);
}

component main = A(3);
