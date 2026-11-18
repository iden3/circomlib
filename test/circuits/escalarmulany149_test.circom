pragma circom 2.0.0;

include "../../circuits/escalarmulany.circom";
include "../../circuits/bitify.circom";

// EscalarMulAny with a one-bit (last) segment: n = 149 = 1 (mod 148).
template Main() {
    signal input e;
    signal input p[2];
    signal output out[2];

    component n2b = Num2Bits(149);
    component escalarMulAny = EscalarMulAny(149);

    n2b.in <== e;
    for (var i = 0; i < 149; i++) {
        escalarMulAny.e[i] <== n2b.out[i];
    }
    escalarMulAny.p[0] <== p[0];
    escalarMulAny.p[1] <== p[1];

    out[0] <== escalarMulAny.out[0];
    out[1] <== escalarMulAny.out[1];
}

component main = Main();
