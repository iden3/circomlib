pragma circom 2.1.5;

include "../../circuits/montgomery.circom";

template Main(){
    input Point a;
    output Point out;
    out <== MontgomeryDouble()(MontgomeryBabyCheck()(a));
}


component main = Main();
