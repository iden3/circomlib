# `EdDSAPoseidonVerifier()`

## Description

This template verifies an [EdDSA](../) signature `S` on a message `msg` on Baby Jubjub elliptic curve using [Poseidon](../../hash_functions/poseidon) hash function.

## Schema

TODO: Make the schema more explicit

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