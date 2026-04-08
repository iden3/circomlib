pragma circom 2.0.0;
include "../../circuits/babyjub.circom";
include "../../circuits/tags-managing.circom";

template BabyPbk_aux() {
    input signal in;
    output Point {babyedwards} pout;

    var r = 2736030358979909402780800718157159386076813972158567259200215660948447373041;
    signal in_aux <== MinMaxValueCheck(1,r-1)(in);
    pout <== BabyPbk()(in_aux);
}

component main = BabyPbk_aux();
