# `EdDSAMiMCSpongeVerifier()`

## Description

This template ... . (verifies an EdDSA signature S on a message msg on Baby Jubjub elliptic curve)

## Background

This is a general overview of how EdDSA works on Baby Jubjub:
1. blabla
https://tools.ietf.org/html/rfc8032

## Schema

TODO: Make the schema more explicit

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
include "../../baby_jubjub/baby_edwards_bits2point_strict/baby_edwards_bits2point_strict.circom";
include "../../baby_jubjub/baby_edwards_point2bits_strict/baby_edwards_point2bits_strict.circom";
include "../../baby_jubjub/baby_edwards_dbl/baby_edwards_dbl.circom";
include "../../baby_jubjub/baby_edwards_scalar_mul_any/baby_edwards_scalar_mul_any.circom";
include "../../baby_jubjub/baby_edwards_scalar_mul_fix/baby_edwards_scalar_mul_fix.circom";
include "../../hash_functions/pedersen_w4/pedersen_w4.circom";
include "../../../basics/comparators/comp_constant/comp_constant.circom";
include "../../../basics/comparators/is_zero/is_zero.circom";
```

## Expected Inputs

| Input         | Type                              | Description      |
| ------------- | -------------                     | -------------    | 
| `enabled`     | ...                               |  Message    |
| `Ax`          | ... encoding of the point, etc.   |  A = [s]B with B generation of large prime subgroup of E (put ref) here  |
| `Ay`          | ...                               |  ...   |
| `S`           | ...                               |  EdDSA signature    |
| `R8x`         | ...                               |  EdDSA signature    |
| `R8y`         | ...                               |  EdDSA signature    |
| `M`           | ...                               |  EdDSA signature    |

## Outputs

No output!!

## Benchmarks 

## Test