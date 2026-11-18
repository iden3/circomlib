pragma circom 2.0.0;

include "../../circuits/escalarmulfix.circom";
include "../../circuits/bitify.circom";

// EscalarMulFix with n = 249, one of the sizes (247..249) that used to fail to compile.
template Main() {
    signal input e;
    signal output out[2];

    var base[2] = [5299619240641551281634865583518297030282874472190772894086521144482721001553,
                   16950150798460657717958625567821834550301663161624707787222815936182638968203];

    component n2b = Num2Bits(249);
    component escalarMul = EscalarMulFix(249, base);

    n2b.in <== e;
    for (var i = 0; i < 249; i++) {
        escalarMul.e[i] <== n2b.out[i];
    }

    out[0] <== escalarMul.out[0];
    out[1] <== escalarMul.out[1];
}

component main = Main();
