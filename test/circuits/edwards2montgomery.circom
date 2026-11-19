pragma circom 2.1.5;

include "../../circuits/montgomery.circom";
include "../../circuits/babyjub.circom";

template Main(){
    input Point a;
    output Point out;
    // a is assumed to be in the subgroup of order l (the test uses BASE8)
    Point {insubgroupl, babyedwards} checked_a <== BabyCheck()(a);
    out <== Edwards2Montgomery(0)(checked_a);
}


component main = Main();

