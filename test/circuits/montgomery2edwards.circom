pragma circom 2.2.0;

include "../../circuits/montgomery.circom";

template Main(){
    input Point a;
    output Point out;
    out <== Montgomery2Edwards()(MontgomeryBabyCheck()(a));

}


component main = Main();

