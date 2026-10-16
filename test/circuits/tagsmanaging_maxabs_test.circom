pragma circom 2.1.5;

include "../../circuits/tags-managing.circom";

// MaxAbsValueTagCheck: constrains -n <= in <= n and hands the input back
// tagged max_abs = n. n = 1 and n = 2 are the widths where nbits(2 * n)
// exceeds n, so they exercise the bit width passed to the comparator.

template A(n1, n2, n3){
    input signal in1;
    input signal in2;
    input signal in3;

    output signal {max_abs} out1 <== MaxAbsValueTagCheck(n1)(in1);
    output signal {max_abs} out2 <== MaxAbsValueTagCheck(n2)(in2);
    output signal {max_abs} out3 <== MaxAbsValueTagCheck(n3)(in3);

    assert(out1.max_abs == n1);
    assert(out2.max_abs == n2);
    assert(out3.max_abs == n3);
}

component main = A(1, 2, 5);
