pragma circom 2.0.0;

include "../../circuits/escalarmul/escalarmul.circom";
include "../../circuits/bitify.circom";


template Main() {
    input signal in;
    output Point {babyedwards} pout;

    var base[2] = [5299619240641551281634865583518297030282874472190772894086521144482721001553,
            16950150798460657717958625567821834550301663161624707787222815936182638968203];


    component n2b = Num2Bits(253);
    component escalarMul = EscalarMul(253, base);

    Point {babyedwards} aux; // Auxiliar point [0,1]
    aux.x <== 0;
    aux.y <== 1;
    escalarMul.pin <== aux;

    var i;

    in ==> n2b.in;

    n2b.out ==> escalarMul.in;


    escalarMul.pout ==> pout;
}

component main = Main();
