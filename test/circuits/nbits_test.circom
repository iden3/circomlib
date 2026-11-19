pragma circom 2.1.5;
include "../../circuits/bitify.circom";
include "../../circuits/comparators.circom";

// nbits(a) is the number of bits of a as a value in [0, p). The old version compared with
// signed semantics and returned maxbits() from 2**252 up, one bit too many.

template Main() {
    assert(nbits(0) == 1);
    assert(nbits(1) == 1);
    assert(nbits(7) == 3);
    assert(nbits(10) == 4);
    assert(nbits(2**251) == 252);
    assert(nbits(2**252) == 253);
    assert(nbits(2**253 - 1) == 253);
    assert(nbits(2**253) == 254);
    assert(nbits(-1) == maxbits());

    // CompConstant(253, ct) was rejected at compile time for ct in [2**252, 2**253).
    input signal in;
    output signal {binary} out <== CompConstant(253, 2**252)(Num2Bits(253)(in));
}

component main = Main();
