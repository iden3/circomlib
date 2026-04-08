pragma circom 2.1.5;

include "../../circuits/escalarmul/escalarmulany.circom";
include "../../circuits/bitify.circom";

template Main() {
    input signal e;
    input Point p;
    output Point {babyedwards} pout;
    
    Point checked_p <== BabyCheck()(p);

    component n2b = Num2Bits(253);
    component escalarMulAny = EscalarMulAny(253);

    escalarMulAny.pin <== checked_p;

    e ==> n2b.in;
    n2b.out ==> escalarMulAny.e;

    escalarMulAny.pout ==> pout;

}

component main = Main();

