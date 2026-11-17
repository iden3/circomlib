pragma circom 2.1.5;

include "../../circuits/montgomery.circom";

template Main(){
    input Point a;
    input Point b;
    output Point out;
    Point {base, min_scalar, max_scalar, babymontgomery} a_aux;
    a_aux.base = 0;
    a_aux.min_scalar = 1;
    a_aux.max_scalar = 1;
    a_aux <== MontgomeryBabyCheck()(a);
    Point {base, min_scalar, max_scalar, babymontgomery} b_aux;
    b_aux.base = 0;
    b_aux.min_scalar = 2;
    b_aux.max_scalar = 2;
    b_aux <== MontgomeryBabyCheck()(b);
    out <== MontgomeryAdd()(a_aux, b_aux);
}


component main = Main();
