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

| Input         | Type                     | Description      |
| ------------- | -------------            | -------------    | 
| `msg[n]`      | Binary array of `n` bits | Message to be signed.    |
| `A[256]`      | Binary array of 256 bits | Encoding of the point A = [s]B, where `B` is the generator of the large prime subgroup of E (put ref) here  |
| `R8[256]`     | Binary array of 256 bits | ...   |
| `S[256]`      | Binary array of 256 bits | EdDSA signature    |



| Input         | Type            | Description      |
| ------------- | -------------   | -------------    | 
| `enabled`     | Boolean         | </p>If `enabled = 1`, then the templated adds a constraint imposing that the signature is valid.</br>If `enabled = 0`, no constraint is added.</p> | <!-- More precisely: if enabled != 0, the constraint is added. -->
| `Ax`          | Field element   | `x`-coordinate of the Baby Jubjub public key `A`.  |
| `Ay`          | Field element   | `y`-coordinate of the Baby Jubjub public key `A`.  |
| `R8x`         | Field element   | `x`-coordinate of the point `8*R`, where `R` is the first element of the signature `(R, S)`. |
| `R8y`         | Field element   | `y`-coordinate of the point `8*R`, where `R` is the first element of the signature `(R, S)`. |
| `S`           | Field element   | Integer between `1` and `l-1` which is the second element of the signature `(R, S)`.    |

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