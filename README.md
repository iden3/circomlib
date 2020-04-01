# Library of Circom Templates

This is the library of templates of functions for [`circom`](https://github.com/iden3/circom), a circuit compiler for zero-knowledge circuits. 

## Description

- This repository contains a library of circuit templates. 
- All files are copyrighted under 2018 0KIMS association and part of the free software [circom](https://github.com/iden3/circom) (Zero Knowledge Circuit Compiler). 

## Organisation (old)

This respository contains 5 folders:
- `circuits`: it contains the implementation of different cryptographic primitives in circom language.
- `calcpedersenbases`: set of functions in JavaScript used to find a set of points in [Baby Jubjub](https://github.com/barryWhiteHat/baby_jubjub) elliptic curve that serve as basis for the [Pedersen Hash](https://github.com/zcash/zcash/issues/2234).
- `doc`: it contains some circuit schemes in ASCII (must be opened with Monodraw, an ASCII art editor for Mac).
- `src`: it contains implementation of circuits in JavaScript.
- `test`: tests.

A description of the specific circuit templates for the `circuit` folder will be soon updated.

## Structure of the Library (circuits)

- [`basics`](circuits/basics)
    - [`aliascheck`](circuits/basics/aliascheck)
    - [`binary_arithmetic`](circuits/basics/binary_arithmetic)
        - [`binsub`](circuits/basics/binary_arithmetic/binsub)
        - [`binsum`](circuits/basics/binary_arithmetic/binsum)
    - [`bitify`](circuits/basics/bitify)
        - [`bits2num`](circuits/basics/bitify/bits2num)
        - [`bits2num_strict`](circuits/basics/bitify/bits2num_strict)
        - [`num2bits`](circuits/basics/bitify/num2bits)
        - [`num2bits_strict`](circuits/basics/bitify/num2bits_strict)
        - [`num2bitsneg`](circuits/basics/bitify/num2bitsneg)
    - [`comparators`](circuits/basics/comparators)
        - [`forceequalifenabled`](circuits/basics/comparators/forceequalifenabled)
        - [`greatereqthan`](circuits/basics/comparators/greatereqthan)
        - [`greaterthan`](circuits/basics/comparators/greaterthan)
        - [`isequal`](circuits/basics/comparators/isequal)
        - [`iszero`](circuits/basics/comparators/iszero)
        - [`lesseqthan`](circuits/basics/comparators/lesseqthan)
        - [`lessthan`](circuits/basics/comparators/lessthan)
    - [`compconstant`](circuits/basics/compconstant)
    - [`logic_gates`](circuits/basics/logic_gates)
        - [`and`](circuits/basics/logic_gates/and)
        - [`multiand`](circuits/basics/logic_gates/multiand)
        - [`nand`](circuits/basics/logic_gates/nand)
        - [`nor`](circuits/basics/logic_gates/nor)
        - [`not`](circuits/basics/logic_gates/not)
        - [`or`](circuits/basics/logic_gates/or)
        - [`xor`](circuits/basics/logic_gates/xor)
    - [`multiplexer`](circuits/basics/multiplexer)
        - [`decoder`](circuits/basics/multiplexer/decoder)
        - [`multiplexer`](circuits/basics/multiplexer/multiplexer)
        - [`scalarproduct`](circuits/basics/multiplexer/scalarproduct)
    - [`mux`](circuits/basics/mux)
        - [`multimux1`](circuits/basics/mux/multimux1)
        - [`multimux2`](circuits/basics/mux/multimux2)
        - [`multimux3`](circuits/basics/mux/multimux3)
        - [`multimux4`](circuits/basics/mux/multimux4)
        - [`mux1`](circuits/basics/mux/mux1)
        - [`mux2`](circuits/basics/mux/mux2)
        - [`mux3`](circuits/basics/mux/mux3)
        - [`mux4`](circuits/basics/mux/mux4)
    - [`sign`](circuits/basics/sign)
    - [`switcher`](circuits/basics/switcher)
- [`cryptography`](circuits/cryptography)
    - [`elliptic_curves`](circuits/cryptography/elliptic_curves)
        - [`baby_jubjub`](circuits/cryptography/elliptic_curves/baby_jubjub)
            - [`edwards`](circuits/cryptography/elliptic_curves/baby_jubjub/edwards)
                - [`babyadd`](circuits/cryptography/elliptic_curves/baby_jubjub/edwards/babyadd)
                - [`babycheck`](circuits/cryptography/elliptic_curves/baby_jubjub/edwards/babycheck)
                - [`babydbl`](circuits/cryptography/elliptic_curves/baby_jubjub/edwards/babydbl)
                - [`babypbk`](circuits/cryptography/elliptic_curves/baby_jubjub/edwards/babypbk)
                - [`scalar_mul`](circuits/cryptography/elliptic_curves/baby_jubjub/edwards/scalar_mul)
                    - [`scalarmul`](circuits/cryptography/elliptic_curves/baby_jubjub/edwards/scalar_mul/scalarmul)
                    - [`scalarmulany`](circuits/cryptography/elliptic_curves/baby_jubjub/edwards/scalar_mul/scalarmulany)
                    - [`scalarmulfix`](circuits/cryptography/elliptic_curves/baby_jubjub/edwards/scalar_mul/scalarmulfix)
                    - [`scalarmulwtable`](circuits/cryptography/elliptic_curves/baby_jubjub/edwards/scalar_mul/scalarmulwtable)
            - [`edwards2montgomery`](circuits/cryptography/elliptic_curves/baby_jubjub/edwards2montgomery)
            - [`montgomery`](circuits/cryptography/elliptic_curves/baby_jubjub/montgomery)
                - [`montgomeryadd`](circuits/cryptography/elliptic_curves/baby_jubjub/montgomery/montgomeryadd)
                - [`montgomerydouble`](circuits/cryptography/elliptic_curves/baby_jubjub/montgomery/montgomerydouble)
            - [`montgomery2edwards`](circuits/cryptography/elliptic_curves/baby_jubjub/montgomery2edwards)
            - [`point2bits`](circuits/cryptography/elliptic_curves/baby_jubjub/point2bits)
    - [`hash_functions`](circuits/cryptography/hash_functions)
        - [`mimc`](circuits/cryptography/hash_functions/mimc)
            - [`mimc7`](circuits/cryptography/hash_functions/mimc/mimc7)
            - [`mimcfeistel`](circuits/cryptography/hash_functions/mimc/mimcfeistel)
            - [`mimcsponge`](circuits/cryptography/hash_functions/mimc/mimcsponge)
            - [`multimimc7`](circuits/cryptography/hash_functions/mimc/multimimc7)
        - [`pedersen`](circuits/cryptography/hash_functions/pedersen)
            - [`pedersen`](circuits/cryptography/hash_functions/pedersen/pedersen)
            - [`pedersen_old`](circuits/cryptography/hash_functions/pedersen/pedersen_old)
        - [`poseidon`](circuits/cryptography/hash_functions/poseidon)
        - [`sha256`](circuits/cryptography/hash_functions/sha256)
    - [`signatures`](circuits/cryptography/signatures)
        - [`eddsa`](circuits/cryptography/signatures/eddsa)
            - [`eddsa`](circuits/cryptography/signatures/eddsa/eddsa)
            - [`eddsamimc`](circuits/cryptography/signatures/eddsa/eddsamimc)
            - [`eddsamimcsponge`](circuits/cryptography/signatures/eddsa/eddsamimcsponge)
            - [`eddsaposeidon`](circuits/cryptography/signatures/eddsa/eddsaposeidon)
    - [`smt`](circuits/cryptography/smt)