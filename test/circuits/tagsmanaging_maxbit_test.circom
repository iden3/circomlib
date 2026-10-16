pragma circom 2.1.5;

include "../../circuits/tags-managing.circom";

// MaxbitCheck and MaxbitCheckArray: constrain the inputs to fit in n bits and
// hand them back tagged maxbit = n. The asserts check the tag itself, which is
// a compile time property and so cannot be checked from the witness.

template A(n, m){
    input signal in;
    input signal ina[m];

    output signal {maxbit} out <== MaxbitCheck(n)(in);
    output signal {maxbit} outa[m] <== MaxbitCheckArray(n, m)(ina);

    assert(out.maxbit == n);
    assert(outa.maxbit == n);
}

component main = A(8, 2);
