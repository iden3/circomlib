pragma circom 2.1.5;

include "../../circuits/montgomery.circom";

template Main(){
    input Point a;
    input Point b;
    output Point out;
    out <== MontgomeryAdd()(MontgomeryBabyCheck()(a), MontgomeryBabyCheck()(b));
}


component main = Main();
