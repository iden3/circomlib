# Baby Jubjub

[Baby Jubjub](https://github.com/ethereum/EIPs/pull/2494) is an elliptic curve defined over the field `F_r`, where `r` is the prime order of alt_bn128 elliptic curve (also referred as BN256), which is the curve currently used to generate and verify zk-SNARK proofs in Ethereum. 

With Baby Jubjub, one can implement complex crytpographic functions, which make use of elliptic curves, inside a zk-SNARK circuit. For instance, we have implemented the [Pedersen hash](https://github.com/iden3/circomlib/tree/organization/circuits/crypto/hash_functions/pedersen_w4) and the [Edwards Digial Signature Algorithm (EdDSA)](https://github.com/iden3/circomlib/tree/organization/circuits/crypto/signatures/eddsa) as a zk-SNARK circuit using Baby Jubjub.

This folder contains the templates to do operations on Baby Jubjub elliptic curve. In this [document](https://github.com/iden3/circomlib/blob/organization/doc/baby_jubjub_arithmetic.md), we briefly describe the curve and how its arithmetic is implemented in the circuits. For more details about the curve, please read [EIP-2494](https://github.com/ethereum/EIPs/pull/2494).

## Structure

- [`baby_edwards2montgomery`](baby_edwards2montgomery)
- [`baby_edwards_add`](baby_edwards_add)
- [`baby_edwards_bits2point`](baby_edwards_bits2point)
- [`baby_edwards_bits2point_strict`](baby_edwards_bits2point_strict)
- [`baby_edwards_check`](baby_edwards_check)
- [`baby_edwards_dbl`](baby_edwards_dbl)
- [`baby_edwards_pbk`](baby_edwards_pbk)
- [`baby_edwards_point2bits`](baby_edwards_point2bits)
- [`baby_edwards_point2bits_strict`](baby_edwards_point2bits_strict)
- [`baby_edwards_scalar_mul`](baby_edwards_scalar_mul)
- [`baby_edwards_scalar_mul_any`](baby_edwards_scalar_mul_any)
- [`baby_edwards_scalar_mul_fix`](baby_edwards_scalar_mul_fix)
- [`baby_montgomery2edwards`](baby_montgomery2edwards)
- [`baby_montgomery_add`](baby_montgomery_add)
- [`baby_montgomery_dbl`](baby_montgomery_dbl)
- [`js`](js)

## TODO:

- baby_edwards_pbk  - test
- change tests of operations so that it also checks js? (see Jordi's old tests)
- TODO: see Jordi!!! - babyjub.js vs babyjub_js.js in tests folder!!!!