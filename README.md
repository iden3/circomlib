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

## Structure of the Library

TODO: CHANGE IT!!!!!

- [`basics`](circomlib-doc/basics)
    - [`aliascheck`](circomlib-doc/basics/aliascheck)
    - [`binary_arithmetic`](circomlib-doc/basics/binary_arithmetic)
        - [`binsub`](circomlib-doc/basics/binary_arithmetic/binsub)
        - [`binsum`](circomlib-doc/basics/binary_arithmetic/binsum)
    - [`bitify`](circomlib-doc/basics/bitify)
        - [`bits2num`](circomlib-doc/basics/bitify/bits2num)
        - [`bits2num_strict`](circomlib-doc/basics/bitify/bits2num_strict)
        - [`num2bits`](circomlib-doc/basics/bitify/num2bits)
        - [`num2bits_strict`](circomlib-doc/basics/bitify/num2bits_strict)
        - [`num2bitsneg`](circomlib-doc/basics/bitify/num2bitsneg)
    - [`comparators`](circomlib-doc/basics/comparators)
        - [`forceequalifenable`](circomlib-doc/basics/comparators/forceequalifenable)
        - [`greatereqthan`](circomlib-doc/basics/comparators/greatereqthan)
        - [`greaterthan`](circomlib-doc/basics/comparators/greaterthan)
        - [`isequal`](circomlib-doc/basics/comparators/isequal)
        - [`iszero`](circomlib-doc/basics/comparators/iszero)
        - [`lesseqthan`](circomlib-doc/basics/comparators/lesseqthan)
        - [`lessthan`](circomlib-doc/basics/comparators/lessthan)
    - [`compconstant`](circomlib-doc/basics/compconstant)
    - [`logic_gates`](circomlib-doc/basics/logic_gates)
        - [`AND`](circomlib-doc/basics/logic_gates/AND)
        - [`MultiAND`](circomlib-doc/basics/logic_gates/MultiAND)
        - [`NAND`](circomlib-doc/basics/logic_gates/NAND)
        - [`NOR`](circomlib-doc/basics/logic_gates/NOR)
        - [`NOT`](circomlib-doc/basics/logic_gates/NOT)
        - [`OR`](circomlib-doc/basics/logic_gates/OR)
        - [`XOR`](circomlib-doc/basics/logic_gates/XOR)
    - [`multiplexer`](circomlib-doc/basics/multiplexer)
    - [`mux`](circomlib-doc/basics/mux)
        - [`multimux1`](circomlib-doc/basics/mux/multimux1)
        - [`multimux2`](circomlib-doc/basics/mux/multimux2)
        - [`multimux3`](circomlib-doc/basics/mux/multimux3)
        - [`multimux4`](circomlib-doc/basics/mux/multimux4)
        - [`mux1`](circomlib-doc/basics/mux/mux1)
        - [`mux2`](circomlib-doc/basics/mux/mux2)
        - [`mux3`](circomlib-doc/basics/mux/mux3)
        - [`mux4`](circomlib-doc/basics/mux/mux4)
    - [`sign`](circomlib-doc/basics/sign)
    - [`switcher`](circomlib-doc/basics/switcher)
- [`cryptography`](circomlib-doc/cryptography)
    - [`hash_functions`](circomlib-doc/cryptography/hash_functions)
        - [`mimc`](circomlib-doc/cryptography/hash_functions/mimc)
            - [`mimc7`](circomlib-doc/cryptography/hash_functions/mimc/mimc7)
            - [`mimcfeistel`](circomlib-doc/cryptography/hash_functions/mimc/mimcfeistel)
            - [`mimcsponge`](circomlib-doc/cryptography/hash_functions/mimc/mimcsponge)
            - [`multimimc7`](circomlib-doc/cryptography/hash_functions/mimc/multimimc7)
        - [`pedersen`](circomlib-doc/cryptography/hash_functions/pedersen)
            - [`segment`](circomlib-doc/cryptography/hash_functions/pedersen/segment)
            - [`window3`](circomlib-doc/cryptography/hash_functions/pedersen/window3)
            - [`window4`](circomlib-doc/cryptography/hash_functions/pedersen/window4)
        - [`poseidon`](circomlib-doc/cryptography/hash_functions/poseidon)
        - [`sha256`](circomlib-doc/cryptography/hash_functions/sha256)
    - [`signatures`](circomlib-doc/cryptography/signatures)
        - [`eddsa`](circomlib-doc/cryptography/signatures/eddsa)
    - [`smt`](circomlib-doc/cryptography/smt)
- [`elliptic_curves`](circomlib-doc/elliptic_curves)
    - [`baby_jubjub`](circomlib-doc/elliptic_curves/baby_jubjub)
        - [`edwards`](circomlib-doc/elliptic_curves/baby_jubjub/edwards)
            - [`babyadd`](circomlib-doc/elliptic_curves/baby_jubjub/edwards/babyadd)
            - [`babycheck`](circomlib-doc/elliptic_curves/baby_jubjub/edwards/babycheck)
            - [`babydbl`](circomlib-doc/elliptic_curves/baby_jubjub/edwards/babydbl)
            - [`babypbk`](circomlib-doc/elliptic_curves/baby_jubjub/edwards/babypbk)
            - [`scalar_mul`](circomlib-doc/elliptic_curves/baby_jubjub/edwards/scalar_mul)
                - [`scalarmul`](circomlib-doc/elliptic_curves/baby_jubjub/edwards/scalar_mul/scalarmul)
                - [`scalarmulany`](circomlib-doc/elliptic_curves/baby_jubjub/edwards/scalar_mul/scalarmulany)
                - [`scalarmulfix`](circomlib-doc/elliptic_curves/baby_jubjub/edwards/scalar_mul/scalarmulfix)
                - [`scalarmulwtable`](circomlib-doc/elliptic_curves/baby_jubjub/edwards/scalar_mul/scalarmulwtable)
        - [`edwards2montgomery`](circomlib-doc/elliptic_curves/baby_jubjub/edwards2montgomery)
        - [`montgomery`](circomlib-doc/elliptic_curves/baby_jubjub/montgomery)
            - [`montgomeryadd`](circomlib-doc/elliptic_curves/baby_jubjub/montgomery/montgomeryadd)
            - [`montgomerydouble`](circomlib-doc/elliptic_curves/baby_jubjub/montgomery/montgomerydouble)
        - [`montgomery2edwards`](circomlib-doc/elliptic_curves/baby_jubjub/montgomery2edwards)
        - [`point2bits`](circomlib-doc/elliptic_curves/baby_jubjub/point2bits)
