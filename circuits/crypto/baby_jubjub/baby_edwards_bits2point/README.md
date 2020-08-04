# `BabyEdwardsBits2Point()`

## Description

This template recieves a binary number of 256 bits (less than `r`)  and returns a point on twisted Edwards [Baby Jubjub curve](https://github.com/ethereum/EIPs/pull/2494).

## Schema

```
               ___________________________     
              |                           |
in[256] ----> |  BabyEdwardsBits2Point()  | ----> out[2]
              |___________________________|     
```

## Dependencies

```
include "../baby_edwards_check/baby_edwards_check.circom"
include "../../../basics/bitify/bits2num/bits2num.circom";
include "../../../basics/bitify/num2bits/num2bits.circom";
include "../../../basics/comparators/comp_constant/comp_constant.circom";
```

## Expected Inputs

| Input         | Type                     |
| ------------- | -------------            |
| `in[256]`     | Binary array of 256 bits |

**Requirement**: the binary number `in[256]` is expected to be be less than `r`, where
```
r = 21888242871839275222246405745257275088548364400416034343698204186575808495617
```

## Outputs

| Output        | Type                          | Description         |
| ------------- | -------------                 | -------------       | 
| `out[2]`      | Array of 2 field elements     | Coordinates `(x,y)` of a point on Baby Jubjub twisted Edwards curve.|


## Benchmarks 

## Test