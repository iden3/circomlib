pragma circom 2.0.0;
include "../../circuits/babyjub.circom";
include "../../circuits/tags-managing.circom";

// maxvalue = -1 = p - 1 reads as negative in circom's signed comparison, so it used to pass
// BabyPbk's assert(in.maxvalue < r). This circuit must not compile.

template BabyPbk_badtag() {
    input signal in;
    output Point {babyedwards} pout;

    signal in_aux <== MinMaxValueCheck(1, -1)(in);
    pout <== BabyPbk()(in_aux);
}

component main = BabyPbk_badtag();
