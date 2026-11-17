pragma circom 2.1.5;

include "../../circuits/montgomery.circom";

template Main(){
    input Point a;
    output Point out;
    Point {base, min_scalar, max_scalar, babymontgomery} a_aux;
    a_aux.base = 0;
    a_aux.min_scalar = 1;
    a_aux.max_scalar = 1;
    a_aux <== MontgomeryBabyCheck()(a);
    out <== Montgomery2Edwards()(a_aux);

}


component main = Main();

