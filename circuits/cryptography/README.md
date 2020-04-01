# `cryptography`

This folder contains the templates to compute cryptographic functions, such as hash functions and signatures. 

## Structure of the folder

- [`hash_functions`](hash_functions)
    - [`mimc`](hash_functions/mimc)
        - [`mimc7`](hash_functions/mimc/mimc7)
        - [`mimcfeistel`](hash_functions/mimc/mimcfeistel)
        - [`mimcsponge`](hash_functions/mimc/mimcsponge)
        - [`multimimc7`](hash_functions/mimc/multimimc7)
    - [`pedersen`](hash_functions/pedersen)
        - [`segment`](hash_functions/pedersen/segment)
        - [`window3`](hash_functions/pedersen/window3)
        - [`window4`](hash_functions/pedersen/window4)
    - [`poseidon`](hash_functions/poseidon)
    - [`sha256`](hash_functions/sha256)
- [`signatures`](signatures)
    - [`eddsa`](signatures/eddsa)
- [`smt`](smt)