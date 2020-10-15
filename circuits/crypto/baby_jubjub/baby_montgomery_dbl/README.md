# `MontgomeryDbl()`

## Description

This templates double a point on the [Baby Jubjub curve](https://github.com/ethereum/EIPs/pull/2494) in Montgomery form. More specifically, given a point `P` it returns the point `Q = 2*P`.

## Schema

```
             ___________________     
            |                   |  
in[2] ----> |  MontgomeryDbl()  | ----> out[2]
            |___________________|     
```

## Dependencies

None.

## Expected Inputs

| Input         | Type           | Description         |                                            
| ------------- | -------------  | -------------       | 
| `in[2]`       | Array of 2 field elements  | Coordinates `(x, y)` of a point on Montgomery Baby Jubjub curve. More precisely, `in[0] = x` and `in[1] = y`.  |

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out[2]`      | Array of 2 field elements  | Coordinates `(x, y)` of the doubling point `(x, y) = 2 * (in[0], in[1])` on Montgomery Baby Jubjub curve. More precisely, `out[0] = x` and `out[1] = y`. |

## Benchmarks 

```
Number of Wires: 7
Number of Constraints: 4
Number of Private Inputs: 0
Number of Public Inputs: 2
Number of Outputs: 2
```