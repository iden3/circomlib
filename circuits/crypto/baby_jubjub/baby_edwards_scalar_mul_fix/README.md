# `BabyEdwardsScalarMulFix(n, BASE)`

## Description

This template... . 

## Schema

```
            ____________________________________     
           |                                    |
e[n] ----> |  BabyEdwardsScalarMulFix(n, BASE)  | ----> out[2]
           |____________________________________|
```

## Dependencies

```
include "_segment_mul_fix.circom";
include "../baby_edwards_add/baby_edwards_add.circom";
include "../baby_montgomery2edwards/baby_montgomery2edwards.circom";
```
Internally, it also requires
```
include "_window_mul_fix.circom";
include "../baby_edwards2montgomery/baby_edwards2montgomery.circom";
include "../baby_montgomery2edwards/baby_montgomery2edwards.circom";
include "../baby_montgomery_add/baby_montgomery_add.circom";
include "../baby_montgomery_dbl/baby_montgomery_dbl.circom";
include "../../../basics/multiplexer/multi_mux3/multi_mux3.circom";
include "../../../basics/multiplexer/multi_mux3/multi_mux3.circom";
```

## Expected Inputs

  signal input e[n];        // Input in binary format
  signal output out[2];     

| Input         | Type           | Description         |                                            
| ------------- | -------------  | -------------       | 
| `e[n]`       | ... (Binary format!)  | ...  |

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out[2]`      | Array of 2 field elements  | Coordinates `(x, y)` of the point ...  |

## Benchmarks 

## Test