# `EdDSAPoseidonVerifier()`

## Description

This template verifies an [EdDSA](../) signature `(R, S)` on a message `M` on Baby Jubjub elliptic curve using [Poseidon](../../hash_functions/poseidon) hash function.

## Schema

```
               ___________________________     
enabled ----> |                           |
     Ax ----> |                           |
     Ay ----> |                           |
      S ----> |  EdDSAPoseidonVerifier()  |
    R8x ----> |                           |
    R8y ----> |                           |
      M ----> |___________________________|
```

## Dependencies

```
include "../../hash_functions/poseidon/poseidon.circom";
include "../../baby_jubjub/baby_edwards_add/baby_edwards_add.circom";
include "../../baby_jubjub/baby_edwards_dbl/baby_edwards_dbl.circom";
include "../../baby_jubjub/baby_edwards_scalar_mul_any/baby_edwards_scalar_mul_any.circom";
include "../../baby_jubjub/baby_edwards_scalar_mul_fix/baby_edwards_scalar_mul_fix.circom";
include "../../../basics/bitify/num2bits/num2bits.circom";
include "../../../basics/bitify/num2bits_strict/num2bits_strict.circom";
include "../../../basics/comparators/comp_constant/comp_constant.circom";
include "../../../basics/comparators/is_zero/is_zero.circom";
include "../../../basics/comparators/force_equal_if_enabled/force_equal_if_enabled.circom";
```

## Expected Inputs


| Input         | Type            | Description      |
| ------------- | -------------   | -------------    | 
| `enabled`     | Boolean         | </p>If `enabled = 1`, then the templated adds a constraint imposing that the signature is valid.</br>If `enabled = 0`, no constraint is added.</p> | <!-- More precisely: if enabled != 0, the constraint is added. -->
| `Ax`          | Field element   | `x`-coordinate of the Baby Jubjub public key `A`.  |
| `Ay`          | Field element   | `y`-coordinate of the Baby Jubjub public key `A`.  |
| `R8x`         | Field element   | `x`-coordinate of the point `8*R`, where `R` is the first element of the signature `(R, S)`. |
| `R8y`         | Field element   | `y`-coordinate of the point `8*R`, where `R` is the first element of the signature `(R, S)`. |
| `S`           | Field element   | Integer between `1` and `l-1` which is the second element of the signature `(R, S)`.    |
| `M`           | Field element   |  Message to be signed.  |

## Outputs

There is no output.

## Benchmarks 

```
Number of Wires: 4208
Number of Constraints: 4209
Number of Private Inputs: 0
Number of Public Inputs: 7
Number of Outputs: 0
```