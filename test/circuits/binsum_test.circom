pragma circom 2.0.0;

include "../../circuits/bitify.circom";
include "../../circuits/binsum.circom";

template A() {
    input signal a; //private
    input signal b;
    output signal out;

    var i;

    component n2ba = Num2Bits(32);
    component n2bb = Num2Bits(32);
    component sum = BinSum(32,2);
    component b2n = Bits2Num(33); 

    n2ba.in <== a;
    n2bb.in <== b;

    sum.in[0] <== n2ba.out;
    sum.in[1] <== n2bb.out;

    b2n.in <== sum.out;

    out <== b2n.out;
}

component main = A();
