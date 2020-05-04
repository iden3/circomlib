# `crypto`

This folder contains the templates to compute cryptographic functions, such as hash functions and signatures. 

* mimc - SNARK-friendly hash Minimal Multiplicative Complexity.
  * https://eprint.iacr.org/2016/492.pdf
  * zcash/zcash#2233
* smt - Sparse Merkle Tree
  * https://ethresear.ch/t/optimizing-sparse-merkle-trees/3751

## Structure of the folder

- [`baby_jubjub`](baby_jubjub)
    - [`baby_edwards2montgomery`](baby_jubjub/baby_edwards2montgomery)
    - [`baby_edwards_add`](baby_jubjub/baby_edwards_add)
    - [`baby_edwards_bits2point`](baby_jubjub/baby_edwards_bits2point)
    - [`baby_edwards_bits2point_strict`](baby_jubjub/baby_edwards_bits2point_strict)
    - [`baby_edwards_check`](baby_jubjub/baby_edwards_check)
    - [`baby_edwards_dbl`](baby_jubjub/baby_edwards_dbl)
    - [`baby_edwards_pbk`](baby_jubjub/baby_edwards_pbk)
    - [`baby_edwards_point2bits`](baby_jubjub/baby_edwards_point2bits)
    - [`baby_edwards_point2bits_strict`](baby_jubjub/baby_edwards_point2bits_strict)
    - [`baby_edwards_scalar_mul`](baby_jubjub/baby_edwards_scalar_mul)
    - [`baby_edwards_scalar_mul_any`](baby_jubjub/baby_edwards_scalar_mul_any)
    - [`baby_edwards_scalar_mul_fix`](baby_jubjub/baby_edwards_scalar_mul_fix)
    - [`baby_montgomery2edwards`](baby_jubjub/baby_montgomery2edwards)
    - [`baby_montgomery_add`](baby_jubjub/baby_montgomery_add)
    - [`baby_montgomery_dbl`](baby_jubjub/baby_montgomery_dbl)
- [`hash_functions`](hash_functions)
    - [`mimc7`](hash_functions/mimc7)
    - [`mimc_sponge`](hash_functions/mimc_sponge)
    - [`multi_mimc7`](hash_functions/multi_mimc7)
    - [`pedersen_old`](hash_functions/pedersen_old)
    - [`pedersen_w3`](hash_functions/pedersen_w3)
    - [`pedersen_w4`](hash_functions/pedersen_w4)
    - [`poseidon`](hash_functions/poseidon)
    - [`sha256`](hash_functions/sha256)
- [`signatures`](signatures)
    - [`eddsa`](signatures/eddsa)
    - [`eddsa_mimc`](signatures/eddsa_mimc)
    - [`eddsa_mimc_sponge`](signatures/eddsa_mimc_sponge)
    - [`eddsa_poseidon`](signatures/eddsa_poseidon)
- [`smt`](smt)