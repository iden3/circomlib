# Library of Circom Templates

This is the library of templates of [`circom`](https://github.com/iden3/circom), a circuit compiler for zero-knowledge circuits. 

## Table of Contents

- [`circuits`](circuits) : it contains several circom circuit templates to perform different kinds of operations. From more basic ones, like comparing two numbers or doing binary arithmetic, to more complex functions, such as elliptic curve operations, validating digital signatures or hashing.
  - [`basics`](circuits/basics)
    - [`binary_ops`](circuits/basics/binary_ops)
        - [`bin_sub`](circuits/basics/binary_ops/bin_sub)
        - [`bin_sum`](circuits/basics/binary_ops/bin_sum)
        - [`gates`](circuits/basics/binary_ops/gates)
            - [`and`](circuits/basics/binary_ops/gates/and)
            - [`multi_and`](circuits/basics/binary_ops/gates/multi_and)
            - [`multi_or`](circuits/basics/binary_ops/gates/multi_or)
            - [`multi_xor`](circuits/basics/binary_ops/gates/multi_xor)
            - [`nand`](circuits/basics/binary_ops/gates/nand)
            - [`nor`](circuits/basics/binary_ops/gates/nor)
            - [`not`](circuits/basics/binary_ops/gates/not)
            - [`or`](circuits/basics/binary_ops/gates/or)
            - [`xor`](circuits/basics/binary_ops/gates/xor)
    - [`bitify`](circuits/basics/bitify)
        - [`bits2num`](circuits/basics/bitify/bits2num)
        - [`bits2num_strict`](circuits/basics/bitify/bits2num_strict)
        - [`num2bits`](circuits/basics/bitify/num2bits)
        - [`num2bits_neg`](circuits/basics/bitify/num2bits_neg)
        - [`num2bits_strict`](circuits/basics/bitify/num2bits_strict)
    - [`comparators`](circuits/basics/comparators)
        - [`alias_check`](circuits/basics/comparators/alias_check)
        - [`comp_constant`](circuits/basics/comparators/comp_constant)
        - [`force_equal_if_enabled`](circuits/basics/comparators/force_equal_if_enabled)
        - [`greater_eq_than`](circuits/basics/comparators/greater_eq_than)
        - [`greater_than`](circuits/basics/comparators/greater_than)
        - [`is_equal`](circuits/basics/comparators/is_equal)
        - [`is_zero`](circuits/basics/comparators/is_zero)
        - [`less_eq_than`](circuits/basics/comparators/less_eq_than)
        - [`less_than`](circuits/basics/comparators/less_than)
        - [`sign`](circuits/basics/comparators/sign)
    - [`multiplexer`](circuits/basics/multiplexer)
        - [`multi_mux1`](circuits/basics/multiplexer/multi_mux1)
        - [`multi_mux2`](circuits/basics/multiplexer/multi_mux2)
        - [`multi_mux3`](circuits/basics/multiplexer/multi_mux3)
        - [`multi_mux4`](circuits/basics/multiplexer/multi_mux4)
        - [`multiplexer`](circuits/basics/multiplexer/multiplexer)
        - [`mux1`](circuits/basics/multiplexer/mux1)
        - [`mux2`](circuits/basics/multiplexer/mux2)
        - [`mux3`](circuits/basics/multiplexer/mux3)
        - [`mux4`](circuits/basics/multiplexer/mux4)
        - [`switcher`](circuits/basics/multiplexer/switcher)
  - [`crypto`](circuits/crypto)
    - [`baby_jubjub`](circuits/crypto/baby_jubjub)
        - [`baby_edwards2montgomery`](circuits/crypto/baby_jubjub/baby_edwards2montgomery)
        - [`baby_edwards_add`](circuits/crypto/baby_jubjub/baby_edwards_add)
        - [`baby_edwards_bits2point`](circuits/crypto/baby_jubjub/baby_edwards_bits2point)
        - [`baby_edwards_bits2point_strict`](circuits/crypto/baby_jubjub/baby_edwards_bits2point_strict)
        - [`baby_edwards_check`](circuits/crypto/baby_jubjub/baby_edwards_check)
        - [`baby_edwards_dbl`](circuits/crypto/baby_jubjub/baby_edwards_dbl)
        - [`baby_edwards_pbk`](circuits/crypto/baby_jubjub/baby_edwards_pbk)
        - [`baby_edwards_point2bits`](circuits/crypto/baby_jubjub/baby_edwards_point2bits)
        - [`baby_edwards_point2bits_strict`](circuits/crypto/baby_jubjub/baby_edwards_point2bits_strict)
        - [`baby_edwards_scalar_mul`](circuits/crypto/baby_jubjub/baby_edwards_scalar_mul)
        - [`baby_edwards_scalar_mul_any`](circuits/crypto/baby_jubjub/baby_edwards_scalar_mul_any)
        - [`baby_edwards_scalar_mul_fix`](circuits/crypto/baby_jubjub/baby_edwards_scalar_mul_fix)
        - [`baby_montgomery2edwards`](circuits/crypto/baby_jubjub/baby_montgomery2edwards)
        - [`baby_montgomery_add`](circuits/crypto/baby_jubjub/baby_montgomery_add)
        - [`baby_montgomery_dbl`](circuits/crypto/baby_jubjub/baby_montgomery_dbl)
    - [`hash_functions`](circuits/crypto/hash_functions)
        - [`mimc7`](circuits/crypto/hash_functions/mimc7)
        - [`mimc_sponge`](circuits/crypto/hash_functions/mimc_sponge)
        - [`multi_mimc7`](circuits/crypto/hash_functions/multi_mimc7)
        - [`pedersen_old`](circuits/crypto/hash_functions/pedersen_old)
        - [`pedersen_w3`](circuits/crypto/hash_functions/pedersen_w3)
        - [`pedersen_w4`](circuits/crypto/hash_functions/pedersen_w4)
        - [`poseidon`](circuits/crypto/hash_functions/poseidon)
        - [`sha256`](circuits/crypto/hash_functions/sha256)
    - [`signatures`](circuits/crypto/signatures)
        - [`eddsa`](circuits/crypto/signatures/eddsa)
        - [`eddsa_mimc`](circuits/crypto/signatures/eddsa_mimc)
        - [`eddsa_mimc_sponge`](circuits/crypto/signatures/eddsa_mimc_sponge)
        - [`eddsa_poseidon`](circuits/crypto/signatures/eddsa_poseidon)
    - [`smt`](circuits/crypto/smt)
- [`doc`](doc) : documentation about some of the more complicated circuits. It contains some Markdown files and some circuit schemes in ASCII. The latter must be opened with Monodraw, an ASCII art editor for Mac.
- [`src`](src) : utils written in JavaScript for deploying contracts. These files are used in some tests.

Auxiliary files:
- [.eslintrc.js](.eslintrc.js)
- [.gitignore](.gitignore)
- [`node_modules`](node_modules)
- [index.js](index.js)
- [package.json](package.json)
- [package-lock.json](package-lock.json)
- [README.md](README.md)
- [LICENSE](LICENSE)

## Contribute to this Repository

Anyone is welcome to contribute with code, tests, documentation, bugs spotting or any small fix! If you would like to contribute, check first out if there are already any open [issues](https://github.com/iden3/circomlib/issues) related to your contribution and if not, please [open a new issue](https://github.com/iden3/circomlib/issues/new) or submit a [pull request](https://github.com/iden3/circomlib/pulls).

Thank you for your help!

## Disclaimer

This repository is still under development and **not ready for production**.  

## License

This repository is part of the iden3 project. All files are copyrighted under 2018 0KIMS association and published with GPL-3 license. Please check the [`LICENSE`](/LICENSE) file for more details.