# `BabyEdwardsBits2Point_strict()`

## Description

This template recieves a binary number of 256 bits, checks that such number is less than `r` and returns a point on twisted Edwards [Baby Jubjub curve](https://github.com/ethereum/EIPs/pull/2494).

## Schema

```
               __________________________________     
              |                                  |
in[256] ----> |  BabyEdwardsBits2Point_strict()  | ----> out[2]
              |__________________________________|     
```

## Dependencies

```
include "../baby_edwards_check/baby_edwards_check.circom"
include "../../../basics/bitify/bits2num/bits2num.circom";
include "../../../basics/bitify/num2bits/num2bits.circom";
include "../../../basics/comparators/alias_check/alias_check.circom";
include "../../../basics/comparators/comp_constant/comp_constant.circom";
```

## Expected Inputs

| Input         | Type                     |
| ------------- | -------------            |
| `in[256]`     | Binary array of 256 bits | <!-- Less than r -->

## Outputs

| Output        | Type                          | Description         |
| ------------- | -------------                 | -------------       | 
| `out[2]`      | Array of 2 field elements     | Coordinates `(x,y)` of a point on Baby Jubjub twisted Edwards curve.|


## Benchmarks 

```
Number of Wires: 1294
Number of Constraints: 1045
Number of Private Inputs: 0
Number of Public Inputs: 256
Number of Outputs: 2
```