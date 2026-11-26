pragma circom 2.1.5;

include "../../circuits/tags-managing.circom";

// The largest n MaxAbsValueTagCheck accepts: 2^(maxbits() - 3) - 1.
template A(){
    input signal in;
    output signal {max_abs} out <== MaxAbsValueTagCheck(2**(maxbits() - 3) - 1)(in);
}

component main = A();
