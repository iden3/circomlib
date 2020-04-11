include "scalarmul.circom";

template Main() {
    signal input in[256];
    signal output out[2];

    var i;

    var base[2] = [5299619240641551281634865583518297030282874472190772894086521144482721001553,
                   16950150798460657717958625567821834550301663161624707787222815936182638968203];

    component scalarMul = ScalarMul(256, base);

    scalarMul.inp[0] <== 0;
    scalarMul.inp[1] <== 1;

    for  (i=0; i<256; i++) {
        in[i] ==> scalarMul.in[i];
    }

    scalarMul.out[0] ==> out[0];
    scalarMul.out[1] ==> out[1];
}

component main = Main();
