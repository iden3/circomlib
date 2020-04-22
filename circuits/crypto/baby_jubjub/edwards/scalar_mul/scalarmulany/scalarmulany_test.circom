include "scalarmulany.circom";
include "../../../../../basic_templates/bitify/num2bits/num2bits.circom";

template Main() {
    signal input e;
    signal input p[2];
    signal output out[2];

    component n2b = Num2Bits(253);
    component scalarMulAny = ScalarMulAny(253);

    scalarMulAny.p[0] <== p[0];
    scalarMulAny.p[1] <== p[1];

    var i;

    e ==> n2b.in;

    for  (i=0; i<253; i++) {
        n2b.out[i] ==> scalarMulAny.e[i];
    }

    scalarMulAny.out[0] ==> out[0];
    scalarMulAny.out[1] ==> out[1];
}

component main = Main();

