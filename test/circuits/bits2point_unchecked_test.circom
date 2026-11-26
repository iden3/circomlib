pragma circom 2.1.5;

include "../../circuits/pointbits.circom";

// A caller that moves raw bits straight into a BinaryPoint. Declaring the bus
// grants {binary} without a constraint, so Bits2Point_Strict must check the bits.
template Main() {
    input signal y[254];
    input signal signX;
    output signal out[2];

    BinaryPoint(254) bp;
    for (var i = 0; i < 254; i++) {
        bp.binY[i] <== y[i];
    }
    bp.signX <== signX;

    Point p <== Bits2Point_Strict()(bp);
    out[0] <== p.x;
    out[1] <== p.y;
}

component main = Main();
