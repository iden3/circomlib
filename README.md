# Library of Circom Templates

This is the library of templates of [`circom`](https://github.com/iden3/circom), a circuit compiler for zero-knowledge circuits. 

<!-- 
## Organisation (old)

This respository contains 5 folders:
- `circuits`: it contains the implementation of different cryptographic primitives in circom language.
- `calcpedersenbases`: set of functions in JavaScript used to find a set of points in [Baby Jubjub](https://github.com/barryWhiteHat/baby_jubjub) elliptic curve that serve as basis for the [Pedersen Hash](https://github.com/zcash/zcash/issues/2234).
- `doc`: it contains some circuit schemes in ASCII (must be opened with Monodraw, an ASCII art editor for Mac).

A description of the specific circuit templates for the `circuit` folder will be soon updated.
-->

## Table of Contents

- [`circuits`](circuits)
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
          - [`num2bits_strict`](circuits/basics/bitify/num2bits_strict)
          - [`num2bitsneg`](circuits/basics/bitify/num2bitsneg)
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
              - [`baby_edwards_scalar_mul_w4_table`](circuits/crypto/baby_jubjub/baby_edwards_scalar_mul/baby_edwards_scalar_mul_w4_table)
              - [`baby_edwards_scalar_mul_window`](circuits/crypto/baby_jubjub/baby_edwards_scalar_mul/baby_edwards_scalar_mul_window)
          - [`baby_edwards_scalar_mul_any`](circuits/crypto/baby_jubjub/baby_edwards_scalar_mul_any)
              - [`bit_element_mul_any`](circuits/crypto/baby_jubjub/baby_edwards_scalar_mul_any/bit_element_mul_any)
              - [`multiplexor2`](circuits/crypto/baby_jubjub/baby_edwards_scalar_mul_any/multiplexor2)
              - [`segment_mul_any`](circuits/crypto/baby_jubjub/baby_edwards_scalar_mul_any/segment_mul_any)
          - [`baby_edwards_scalar_mul_fix`](circuits/crypto/baby_jubjub/baby_edwards_scalar_mul_fix)
              - [`segment_mul_fix`](circuits/crypto/baby_jubjub/baby_edwards_scalar_mul_fix/segment_mul_fix)
              - [`window_mul_fix`](circuits/crypto/baby_jubjub/baby_edwards_scalar_mul_fix/window_mul_fix)
          - [`baby_montgomery2edwards`](circuits/crypto/baby_jubjub/baby_montgomery2edwards)
          - [`baby_montgomery_add`](circuits/crypto/baby_jubjub/baby_montgomery_add)
          - [`baby_montgomery_dbl`](circuits/crypto/baby_jubjub/baby_montgomery_dbl)
      - [`hash_functions`](circuits/crypto/hash_functions)
          - [`mimc7`](circuits/crypto/hash_functions/mimc7)
          - [`mimc_feistel`](circuits/crypto/hash_functions/mimc_feistel)
          - [`mimc_sponge`](circuits/crypto/hash_functions/mimc_sponge)
          - [`multi_mimc7`](circuits/crypto/hash_functions/multi_mimc7)
          - [`pedersen_old`](circuits/crypto/hash_functions/pedersen_old)
          - [`pedersen_w3`](circuits/crypto/hash_functions/pedersen_w3)
              - [`segment3`](circuits/crypto/hash_functions/pedersen_w3/segment3)
              - [`window3`](circuits/crypto/hash_functions/pedersen_w3/window3)
          - [`pedersen_w4`](circuits/crypto/hash_functions/pedersen_w4)
              - [`segment`](circuits/crypto/hash_functions/pedersen_w4/segment)
              - [`window4`](circuits/crypto/hash_functions/pedersen_w4/window4)
          - [`poseidon`](circuits/crypto/hash_functions/poseidon)
          - [`sha256`](circuits/crypto/hash_functions/sha256)
              - [`constants`](circuits/crypto/hash_functions/sha256/constants)
      - [`signatures`](circuits/crypto/signatures)
          - [`eddsa`](circuits/crypto/signatures/eddsa)
          - [`eddsamimc`](circuits/crypto/signatures/eddsamimc)
          - [`eddsamimcsponge`](circuits/crypto/signatures/eddsamimcsponge)
          - [`eddsaposeidon`](circuits/crypto/signatures/eddsaposeidon)
      - [`smt`](circuits/crypto/smt)

## Contribute to this Repository

Blabla

## License

The `circomlib` repository is part of the iden3 project. All files are copyrighted under 2018 0KIMS association and published with GPL-3 license. Please check the [`LICENSE`](/LICENSE) file for more details.