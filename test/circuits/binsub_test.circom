pragma circom 2.1.5;

include "../../circuits/bitify.circom";
include "../../circuits/binsub.circom";
include "../../circuits/buses.circom";

template A() {
    input signal a; //private
    input signal b;
    output signal out;

    var i;

    component n2ba = Num2Bits(16);
    component n2bb = Num2Bits(16);
    component sub = BinSub(16);
    component b2n = Bits2Num(16);

    n2ba.in <== a;
    n2bb.in <== b;

    sub.in[0] <== n2ba.out;
    sub.in[1] <== n2bb.out;
    
    b2n.in <== sub.out;

    out <== b2n.out;
}

component main = A();
