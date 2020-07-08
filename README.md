# Library of Circom Templates

This is the library of templates of [`circom`](https://github.com/iden3/circom), a circuit compiler for zero-knowledge circuits. 

## Structure

- [`circuits`](circuits) : it contains several circom circuit templates to perform different kinds of operations. From more basic ones, like comparing two numbers or doing binary arithmetic, to more complex functions, such as elliptic curve operations, validating digital signatures or hashing.
- [`basics`](basics)
    - [`binary_ops`](basics/binary_ops)
        - [`bin_sub`](basics/binary_ops/bin_sub)
        - [`bin_sum`](basics/binary_ops/bin_sum)
        - [`gates`](basics/binary_ops/gates)
            - [`and`](basics/binary_ops/gates/and)
            - [`multi_and`](basics/binary_ops/gates/multi_and)
            - [`multi_or`](basics/binary_ops/gates/multi_or)
            - [`multi_xor`](basics/binary_ops/gates/multi_xor)
            - [`nand`](basics/binary_ops/gates/nand)
            - [`nor`](basics/binary_ops/gates/nor)
            - [`not`](basics/binary_ops/gates/not)
            - [`or`](basics/binary_ops/gates/or)
            - [`xor`](basics/binary_ops/gates/xor)
    - [`bitify`](basics/bitify)
        - [`bits2num`](basics/bitify/bits2num)
        - [`bits2num_strict`](basics/bitify/bits2num_strict)
        - [`num2bits`](basics/bitify/num2bits)
        - [`num2bits_neg`](basics/bitify/num2bits_neg)
        - [`num2bits_strict`](basics/bitify/num2bits_strict)
    - [`comparators`](basics/comparators)
        - [`alias_check`](basics/comparators/alias_check)
        - [`comp_constant`](basics/comparators/comp_constant)
        - [`force_equal_if_enabled`](basics/comparators/force_equal_if_enabled)
        - [`greater_eq_than`](basics/comparators/greater_eq_than)
        - [`greater_than`](basics/comparators/greater_than)
        - [`is_equal`](basics/comparators/is_equal)
        - [`is_zero`](basics/comparators/is_zero)
        - [`less_eq_than`](basics/comparators/less_eq_than)
        - [`less_than`](basics/comparators/less_than)
        - [`sign`](basics/comparators/sign)
    - [`multiplexer`](basics/multiplexer)
        - [`multi_mux1`](basics/multiplexer/multi_mux1)
        - [`multi_mux2`](basics/multiplexer/multi_mux2)
        - [`multi_mux3`](basics/multiplexer/multi_mux3)
        - [`multi_mux4`](basics/multiplexer/multi_mux4)
        - [`mux1`](basics/multiplexer/mux1)
        - [`mux2`](basics/multiplexer/mux2)
        - [`mux3`](basics/multiplexer/mux3)
        - [`mux4`](basics/multiplexer/mux4)
        - [`switcher`](basics/multiplexer/switcher)
- [`crypto`](crypto)
    - [`baby_jubjub`](crypto/baby_jubjub)
        - [`baby_edwards_add`](crypto/baby_jubjub/baby_edwards_add)
        - [`baby_edwards_bits2point`](crypto/baby_jubjub/baby_edwards_bits2point)
        - [`baby_edwards_bits2point_strict`](crypto/baby_jubjub/baby_edwards_bits2point_strict)
        - [`baby_edwards_check`](crypto/baby_jubjub/baby_edwards_check)
        - [`baby_edwards_dbl`](crypto/baby_jubjub/baby_edwards_dbl)
        - [`baby_edwards_pbk`](crypto/baby_jubjub/baby_edwards_pbk)
        - [`baby_edwards_point2bits`](crypto/baby_jubjub/baby_edwards_point2bits)
        - [`baby_edwards_point2bits_strict`](crypto/baby_jubjub/baby_edwards_point2bits_strict)
        - [`baby_edwards_scalar_mul`](crypto/baby_jubjub/baby_edwards_scalar_mul)
        - [`baby_edwards_scalar_mul_any`](crypto/baby_jubjub/baby_edwards_scalar_mul_any)
        - [`baby_edwards_scalar_mul_fix`](crypto/baby_jubjub/baby_edwards_scalar_mul_fix)
        - [`baby_edwards2montgomery`](crypto/baby_jubjub/baby_edwards2montgomery)
        - [`baby_montgomery_add`](crypto/baby_jubjub/baby_montgomery_add)
        - [`baby_montgomery_dbl`](crypto/baby_jubjub/baby_montgomery_dbl)
        - [`baby_montgomery2edwards`](crypto/baby_jubjub/baby_montgomery2edwards)
    - [`hash_functions`](crypto/hash_functions)
        - [`mimc_sponge`](crypto/hash_functions/mimc_sponge)
        - [`pedersen_old`](crypto/hash_functions/pedersen_old)
        - [`pedersen_w4`](crypto/hash_functions/pedersen_w4)
        - [`poseidon`](crypto/hash_functions/poseidon)
        - [`sha256`](crypto/hash_functions/sha256)
    - [`signatures`](crypto/signatures)
        - [`eddsa_pedersen`](crypto/signatures/eddsa_pedersen)
        - [`eddsa_mimc_sponge`](crypto/signatures/eddsa_mimc_sponge)
        - [`eddsa_poseidon`](crypto/signatures/eddsa_poseidon)
    - [`smt`](crypto/smt)
        - [`smt_processor`](crypto/smt/smt_processor)
        - [`smt_verifier`](crypto/smt/smt_verifier)
- [`doc`](doc) : documentation about some of the more complicated circuits. It contains some Markdown files and some circuit schemes in ASCII. The latter must be opened with Monodraw, an ASCII art editor for Mac.
- [`src`](src) : utils written in JavaScript for deploying contracts. These files are used in some tests.

<!-- Auxiliary files:
    - [.eslintrc.js](.eslintrc.js)
    - [.gitignore](.gitignore)
    - [`node_modules`](node_modules)
    - [index.js](index.js)
    - [package.json](package.json)
    - [package-lock.json](package-lock.json)
    - [README.md](README.md)
    - [LICENSE](LICENSE)
-->

## Contribute to this Repository

Anyone is welcome to contribute with code, tests, documentation, bugs spotting or any small fix! If you would like to contribute, check first out if there are already any open [issues](https://github.com/iden3/circomlib/issues) related to your contribution and if not, please [open a new issue](https://github.com/iden3/circomlib/issues/new) or submit a [pull request](https://github.com/iden3/circomlib/pulls).

Thank you for your help!

## Disclaimer

This repository is still under development and **not ready for production**.  

## License

This repository is part of the iden3 project. All files are copyrighted under 2018 0KIMS association and published with GPL-3 license. Please check the [`LICENSE`](/LICENSE) file for more details.