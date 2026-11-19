pragma circom 2.1.5;

include "../../circuits/pointbits.circom";


template Main() {
    input signal in[2];

    var i;

    component p2b = Point2Bits_Strict();
    component b2p = Bits2Point_Strict();

    Point p;
    p.x <== in[0];
    p.y <== in[1];
    p2b.pin <== BabyCheck()(p);

    b2p.in <== p2b.out;

    b2p.pout === p2b.pin;
}

component main = Main();
