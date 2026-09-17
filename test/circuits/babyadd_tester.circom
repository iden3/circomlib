pragma circom 2.2.0;
include "../../circuits/babyjub.circom";

template Main(){
    input Point a;
    input Point b;
    //output Point out <== BabyAdd()(BabyCheck()(a), BabyCheck()(b));
    Point {babyedwards} a_aux <== a;
    Point {babyedwards} b_aux <== b;
    output Point out <== BabyAdd()(a_aux, b_aux);
}


component main = Main();
