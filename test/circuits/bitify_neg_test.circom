pragma circom 2.1.5;

include "../../circuits/bitify.circom";

// Num2BitsNeg(n) returns the n bits of 2**n - in, and all zeros when in is 0.
// n = 8 keeps 2**n well below the prime; n = 254 is the width at which 2**n
// wraps, which is where the in = 0 case used to have no solution.

template Main(){
    input signal in8;
    input signal in254;

    output signal {binary} out8[8] <== Num2BitsNeg(8)(in8);
    output signal {binary} out254[254] <== Num2BitsNeg(254)(in254);
}

component main = Main();
