pragma circom 2.0.0;

include "../../circuits/mux5.circom";
include "../../circuits/bitify.circom";


template Constants() {
    var i;
    signal output out[32];

    out[0] <== 1230;
    out[1] <== 4560;
    out[2] <== 7890;
    out[3] <== 0120;
    out[4] <== 1110;
    out[5] <== 2220;
    out[6] <== 3330;
    out[7] <== 45460;
    out[8] <== 1345230;
    out[9] <== 443560;
    out[10] <== 156230;
    out[11] <== 45660;
    out[12] <== 12230;
    out[13] <== 45460;
    out[14] <== 42560;
    out[15] <== 44560;

    out[16] <== 1231;
    out[17] <== 4561;
    out[18] <== 7891;
    out[19] <== 0121;
    out[20] <== 1111;
    out[21] <== 2221;
    out[22] <== 3331;
    out[23] <== 45461;
    out[24] <== 1345231;
    out[25] <== 443561;
    out[26] <== 156231;
    out[27] <== 45661;
    out[28] <== 12231;
    out[29] <== 45461;
    out[30] <== 42561;
    out[31] <== 44561;
}

template Main() {
    var i;
    signal input selector;//private
    signal output out;

    component mux = Mux5();
    component n2b = Num2Bits(5);
    component cst = Constants();

    selector ==> n2b.in;
    for (i=0; i<5; i++) {
        n2b.out[i] ==> mux.s[i];
    }
    for (i=0; i<32; i++) {
        cst.out[i] ==> mux.c[i];
    }

    mux.out ==> out;
}

component main = Main();
