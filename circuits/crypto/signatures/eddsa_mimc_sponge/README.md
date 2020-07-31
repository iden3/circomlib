# `EdDSAMiMCSpongeVerifier()`

## Description

This template verifies an [EdDSA](../) signature `S` on a message `msg` on Baby Jubjub elliptic curve using [MiMC-Sponge](../../hash_functions/mimc_sponge) hash function.

## Schema

```
               _____________________________     
enabled ----> |                             |
     Ax ----> |                             |
     Ay ----> |                             |
      S ----> |  EdDSAMiMCSpongeVerifier()  |
    R8x ----> |                             |
    R8y ----> |                             |
      M ----> |_____________________________|
```

## Dependencies

```
include "../../../basics/comparators/comp_constant/comp_constant.circom";
include "../../../basics/comparators/is_zero/is_zero.circom";
include "../../../basics/comparators/force_equal_if_enabled/force_equal_if_enabled.circom";
include "../../../basics/bitify/num2bits/num2bits.circom";
include "../../../basics/bitify/num2bits_strict/num2bits_strict.circom";
include "../../baby_jubjub/baby_edwards_add/baby_edwards_add.circom";
include "../../baby_jubjub/baby_edwards_dbl/baby_edwards_dbl.circom";
include "../../baby_jubjub/baby_edwards_scalar_mul_any/baby_edwards_scalar_mul_any.circom";
include "../../baby_jubjub/baby_edwards_scalar_mul_fix/baby_edwards_scalar_mul_fix.circom";
include "../../hash_functions/mimc_sponge/mimc_sponge.circom";
```

## Expected Inputs

| Input         | Type            | Description      |
| ------------- | -------------   | -------------    | 
| `enabled`     | Boolean         | If `enabled = 1`, then . Otherwise, no constraint is added.    |
| `Ax`          | Field element   | `x`-coordinate of the Baby Jubjub public key `A`  |
| `Ay`          | Field element   | `y`-coordinate of the Baby Jubjub public key `A`  |
| `R8x`         | Field element   | `x`-coordinate of the point `8*R`, where `R` is the first element of the signature `(R, S)` |
| `R8y`         | Field element   | `y`-coordinate of the point `8*R`, where `R` is the first element of the signature `(R, S)` |
| `S`           | Field element   | Integer between `1` and `l-1` which is the second element of the signature `(R, S)`    |
| `M`           | Field element   |  Message to be signed  |

## Outputs

There is no output.

## Benchmarks 

## Test