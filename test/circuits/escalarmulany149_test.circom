pragma circom 2.1.5;

include "../../circuits/escalarmul/escalarmulany.circom";
include "../../circuits/bitify.circom";

// EscalarMulAny with a one-bit (last) segment: n = 149 = 1 (mod 148).
template Main() {
    input signal e;
    input Point p;
    output Point {babyedwards} pout;

    // p is assumed to be in the subgroup of order l or the identity (the test uses BASE8)
    Point {insubgrouplorunit, babyedwards} checked_p <== BabyCheck()(p);

    component n2b = Num2Bits(149);
    component escalarMulAny = EscalarMulAnyOrUnit(149);

    escalarMulAny.pin <== checked_p;

    e ==> n2b.in;
    n2b.out ==> escalarMulAny.e;

    escalarMulAny.pout ==> pout;
}

component main = Main();
