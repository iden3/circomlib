# `BabyEdwardsScalarMul(n, base)`

## Description

This template... . 

## Schema

```
               _________________________________     
 in[n] ---->  |                                 |
              |  BabyEdwardsScalarMul(n, base)  | ----> out[2]
inp[2] ---->  |_________________________________|
```

## Dependencies

```
include "_baby_edwards_scalar_mul_window.circom";
```
Internally, it also requires
```
include "_baby_edwards_scalar_mul_w4table.circom";
include "../../../basics/multiplexer/multi_mux4/multi_mux4.circom";
include "../baby_edwards_add/baby_edwards_add.circom";
```

## Expected Inputs

| Input         | Type           | Description         |                                            
| ------------- | -------------  | -------------       | 
| `in[n]`       | ...  | ...  |
| `inp[2]`      | ...  | ...  |

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out[2]`      | Array of 2 field elements  | Coordinates `(x, y)` of the point ...  |

## Benchmarks 

## Test