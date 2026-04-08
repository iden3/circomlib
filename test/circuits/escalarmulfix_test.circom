pragma circom 2.1.5;

include "../../circuits/escalarmul/escalarmulfix.circom";
include "../../circuits/bitify.circom";


template Main() {
    input signal e;
    output Point {babyedwards} pout;

    var base[2] = [5299619240641551281634865583518297030282874472190772894086521144482721001553,
                   16950150798460657717958625567821834550301663161624707787222815936182638968203];


    component n2b = Num2Bits(253);
    component escalarMul = EscalarMulFix(253, base);

    var i;

    e ==> n2b.in;

    n2b.out ==> escalarMul.e;

    escalarMul.pout ==> pout;
}

component main = Main();

