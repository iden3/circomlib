pragma circom 2.1.5;

include "../../circuits/bitify.circom";

// Num2BitsNeg(n) returns the n bits of 2**n - in, and all zeros when in is 0.
// n = 8 keeps 2**n well below the prime; n = 253 is the widest the template allows,
// 2**253 being the largest power of two below the prime. 254 is rejected at compile time.

template Main(){
    input signal in8;
    input signal in253;

    output signal {binary} out8[8] <== Num2BitsNeg(8)(in8);
    output signal {binary} out253[253] <== Num2BitsNeg(253)(in253);
}

component main = Main();
