pragma circom 2.1.5;

include "../../circuits/tags-managing.circom";

// MaxValueCheck, MinValueCheck and MinMaxValueCheck: constrain the input
// against constant bounds and hand it back tagged with those bounds.

template A(ctmax, ctmin, ct1, ct2){
    input signal inmax;
    input signal inmin;
    input signal inrange;

    output signal {maxvalue} outmax <== MaxValueCheck(ctmax)(inmax);
    output signal {minvalue} outmin <== MinValueCheck(ctmin)(inmin);
    output signal {minvalue,maxvalue} outrange <== MinMaxValueCheck(ct1, ct2)(inrange);

    assert(outmax.maxvalue == ctmax);
    assert(outmin.minvalue == ctmin);
    assert(outrange.minvalue == ct1);
    assert(outrange.maxvalue == ct2);
}

component main = A(100, 7, 10, 20);
