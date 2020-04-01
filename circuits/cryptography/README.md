# `cryptography`

This folder contains the templates to compute cryptographic functions, such as hash functions and signatures. 

## Structure of the folder

- [`hash_functions`](doc/cryptography/hash_functions)
    - [`mimc`](doc/cryptography/hash_functions/mimc)
        - [`mimc7`](doc/cryptography/hash_functions/mimc/mimc7)
        - [`mimcfeistel`](doc/cryptography/hash_functions/mimc/mimcfeistel)
        - [`mimcsponge`](doc/cryptography/hash_functions/mimc/mimcsponge)
        - [`multimimc7`](doc/cryptography/hash_functions/mimc/multimimc7)
    - [`pedersen`](doc/cryptography/hash_functions/pedersen)
        - [`segment`](doc/cryptography/hash_functions/pedersen/segment)
        - [`window3`](doc/cryptography/hash_functions/pedersen/window3)
        - [`window4`](doc/cryptography/hash_functions/pedersen/window4)
    - [`poseidon`](doc/cryptography/hash_functions/poseidon)
    - [`sha256`](doc/cryptography/hash_functions/sha256)
- [`signatures`](doc/cryptography/signatures)
    - [`eddsa`](doc/cryptography/signatures/eddsa)
- [`smt`](doc/cryptography/smt)