include "../baby_edwards_scalar_mul.circom";
include "../../../../basics/bitify/num2bits/num2bits.circom";

template Main() {
    signal input in;
    signal output out[2];

    var base[2] = [5299619240641551281634865583518297030282874472190772894086521144482721001553,
            16950150798460657717958625567821834550301663161624707787222815936182638968203];


    component n2b = Num2Bits(253);
    component scalarMul = BabyEdwardsScalarMul(253, base);

    scalarMul.inp[0] <== 0;
    scalarMul.inp[1] <== 1;

    var i;

    in ==> n2b.in;

    for  (i=0; i<253; i++) {
        n2b.out[i] ==> scalarMul.in[i];
    }

    scalarMul.out[0] ==> out[0];
    scalarMul.out[1] ==> out[1];
}

component main = Main();
