pragma circom 2.1.5;

include "../../circuits/montgomery.circom";
include "../../circuits/babyjub.circom";

template Main(){
    input Point a;
    output Point out;
    out <== Edwards2Montgomery(0)(NonZeroXCheck()(BabyCheck()(a)));
}


component main = Main();

