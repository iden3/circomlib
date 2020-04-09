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

* mimc - SNARK-friendly hash Minimal Multiplicative Complexity.
  * https://eprint.iacr.org/2016/492.pdf
  * zcash/zcash#2233
* smt - Sparse Merkle Tree
  * https://ethresear.ch/t/optimizing-sparse-merkle-trees/3751