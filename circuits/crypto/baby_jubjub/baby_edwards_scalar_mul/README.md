# `BabyEdwardsScalarMul(n, base)`

## Description

This template multiplies ... . 

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
include "../baby_edwards_add/baby_edwards_add.circom";
include "../../../basics/multiplexer/multi_mux4/multi_mux4.circom";
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

With
```
base = [5299619240641551281634865583518297030282874472190772894086521144482721001553,    
       16950150798460657717958625567821834550301663161624707787222815936182638968203]
```
and `n = 253`:
```
Number of Wires: 1018
Number of Constraints: 762
Number of Private Inputs: 0
Number of Public Inputs: 255
Number of Outputs: 2
```