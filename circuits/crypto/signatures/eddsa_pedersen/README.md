# `EdDSAPedersenVerifier(n)`

## Description

This template verifies an [EdDSA](../) signature `(R, S)` on a message `M` on Baby Jubjub elliptic curve using [Pedersen](../../hash_functions/pedersen_w4) hash function.


## Schema

```
               ____________________________     
 msg[n] ----> |                            |
 A[256] ----> |                            |
              |  EdDSAPedersenVerifier(n)  |
R8[256] ----> |                            |
 S[256] ----> |____________________________|     
```

## Dependencies

```
include "../../hash_functions/pedersen_w4/pedersen_w4.circom";
include "../../baby_jubjub/baby_edwards_bits2point_strict/baby_edwards_bits2point_strict.circom";
include "../../baby_jubjub/baby_edwards_point2bits_strict/baby_edwards_point2bits_strict.circom";
include "../../baby_jubjub/baby_edwards_dbl/baby_edwards_dbl.circom";
include "../../baby_jubjub/baby_edwards_scalar_mul_any/baby_edwards_scalar_mul_any.circom";
include "../../baby_jubjub/baby_edwards_scalar_mul_fix/baby_edwards_scalar_mul_fix.circom";
include "../../../basics/comparators/comp_constant/comp_constant.circom";
include "../../../basics/comparators/is_zero/is_zero.circom";```
```

## Expected Inputs

| Input         | Type                              | Description      |
| ------------- | -------------                     | -------------    | 
| `msg[n]`      | ...                               |  Message    |
| `A[256]`      | ... encoding of the point, etc.   |  A = [s]B with B generation of large prime subgroup of E (put ref) here  |
| `R8[256]`     | ...                               |  ...   |
| `S[256]`      | ...                               |  EdDSA signature    |

## Outputs

There is no output.

## Benchmarks 

With `n = 80`:
```
Number of Wires: 8391
Number of Constraints: 7572
Number of Private Inputs: 0
Number of Public Inputs: 848
Number of Outputs: 0
```