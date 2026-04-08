pragma circom 2.1.5;

include "../../circuits/mux3.circom";
include "../../circuits/bitify.circom";


template Constants() {
    var i;
    output signal out[8];

    out[0] <== 37;
    out[1] <== 47;
    out[2] <== 53;
    out[3] <== 71;
    out[4] <== 89;
    out[5] <== 107;
    out[6] <== 163;
    out[7] <== 191;
}

template Main() {
    input signal selector;//private
    output signal out;

    component mux = Mux3();
    component n2b = Num2Bits(3);
    component cst = Constants();

    selector ==> n2b.in;
    n2b.out ==> mux.s;
    cst.out ==> mux.c;

    mux.out ==> out;
}

component main = Main();
