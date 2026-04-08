pragma circom 2.1.5;

include "../../circuits/montgomery.circom";
include "../../circuits/babyjub.circom";

template Main(){
    input Point a;
    output Point out;
    Point {babyedwards} a_aux <== a;
    //out <== Edwards2Montgomery()(BabyCheck()(a));
    out <== Edwards2Montgomery()(a_aux);
}


component main = Main();

