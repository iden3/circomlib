pragma circom 2.1.5;

include "../../circuits/escalarmul/escalarmul.circom";
include "../../circuits/tags-managing.circom";

template Main() {
    input signal in[256];
    output Point {babyedwards} pout;
    
    signal {binary} aux_in[256] <== BinaryCheckArray(256)(in);
    var i;

    var base[2] = [5299619240641551281634865583518297030282874472190772894086521144482721001553, 16950150798460657717958625567821834550301663161624707787222815936182638968203];

    component escalarMul = EscalarMul(256, base);
    Point {babyedwards} paux;
    paux.x <== 0;
    paux.y <== 1;
	
    paux ==> escalarMul.pin; 
    aux_in ==> escalarMul.in;

    escalarMul.pout ==> pout;
}

component main = Main();
