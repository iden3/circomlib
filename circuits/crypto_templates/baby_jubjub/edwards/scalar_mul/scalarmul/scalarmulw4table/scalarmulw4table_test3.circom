include "scalarmulw4table.circom";


template Main() {
    signal input in;
    signal output out[16][2];
    var base[2] = [5299619240641551281634865583518297030282874472190772894086521144482721001553,
                   16950150798460657717958625567821834550301663161624707787222815936182638968203];

    var scalarMul[16][2] = ScalarMulW4Table(base, 3);
    for (var i=0; i<16; i++) {
        out[i][0] <== scalarMul[i][0]*in;
        out[i][1] <== scalarMul[i][1]*in;
    }
}

component main = Main();
