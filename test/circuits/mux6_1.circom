pragma circom 2.0.0;

include "../../circuits/mux6.circom";
include "../../circuits/bitify.circom";


template Constants() {
    var i;
    signal output out[64];

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

    out[32] <== 1232;
    out[33] <== 4562;
    out[34] <== 7892;
    out[35] <== 0122;
    out[36] <== 1112;
    out[37] <== 2222;
    out[38] <== 3332;
    out[39] <== 45462;
    out[40] <== 1345232;
    out[41] <== 443562;
    out[42] <== 156232;
    out[43] <== 45662;
    out[44] <== 12232;
    out[45] <== 45462;
    out[46] <== 42562;
    out[47] <== 44562;

    out[48] <== 1233;
    out[49] <== 4563;
    out[50] <== 7893;
    out[51] <== 0123;
    out[52] <== 1113;
    out[53] <== 2223;
    out[54] <== 3333;
    out[55] <== 45463;
    out[56] <== 1345233;
    out[57] <== 443563;
    out[58] <== 156233;
    out[59] <== 45663;
    out[60] <== 12233;
    out[61] <== 45463;
    out[62] <== 42563;
    out[63] <== 44563;
}

template Main() {
    var i;
    signal input selector;//private
    signal output out;

    component mux = Mux6();
    component n2b = Num2Bits(6);
    component cst = Constants();

    selector ==> n2b.in;
    for (i=0; i<6; i++) {
        n2b.out[i] ==> mux.s[i];
    }
    for (i=0; i<64; i++) {
        cst.out[i] ==> mux.c[i];
    }

    mux.out ==> out;
}

component main = Main();
