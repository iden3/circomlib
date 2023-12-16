pragma circom 2.0.0;
include "../../circuits/babyjub.circom";

template BabyPbk_aux() {
    signal input in;
    signal output Ax;
    signal output Ay;

    var r = 2736030358979909402780800718157159386076813972158567259200215660948447373041;
    signal in_aux <== CMinMaxValueCheck(1,r)(in);
    (Ax,Ay) <== BabyPbk()(in_aux);
}

component main = BabyPbk_aux();
