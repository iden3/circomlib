# `BabyEdwardsScalarMulAny(n)`

## Description

This template... . 

// This function assumes that p is in the subgroup and it is different to 0.

## Schema

```
             ______________________________     
e[n] ---->  |                              |
            |  BabyEdwardsScalarMulAny(n)  | ----> out[2]
p[2] ---->  |______________________________|
```

## Dependencies

```
include "_segment_mul_any.circom";
include "../baby_edwards_add/baby_edwards_add.circom";
include "../baby_montgomery2edwards/baby_montgomery2edwards.circom";
include "../baby_montgomery_dbl/baby_montgomery_dbl.circom";
include "../../../basics/comparators/is_zero/is_zero.circom";
```
Internally, it also requires
```
include "_multiplexor2.circom";
include "_bit_element_mul_any.circom";
include "../baby_edwards2montgomery/baby_edwards2montgomery.circom";
include "../baby_montgomery_add/baby_montgomery_add.circom";
```

## Expected Inputs

// This function assumes that p is in the subgroup and it is different from 0.

| Input         | Type           | Description         |                                            
| ------------- | -------------  | -------------       | 
| `e[n]`       | ...  | ...  |
| `p[2]`      | ...  | ...  |

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out[2]`      | Array of 2 field elements  | Coordinates `(x, y)` of the point ...  |

## Benchmarks 

## Test