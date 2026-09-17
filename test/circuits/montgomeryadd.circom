pragma circom 2.1.5;

include "../../circuits/montgomery.circom";

template Main(){
    input Point a;
    input Point b;
    output Point out;
    Point {babymontgomery} am <== MontgomeryBabyCheck()(a);
    Point {babymontgomery} bm <== MontgomeryBabyCheck()(b);
    // arbitrary inputs, so the distinctness is checked rather than assumed
    out <== MontgomeryAdd()(am, DistinctXCheck()(am, bm));
}


component main = Main();
