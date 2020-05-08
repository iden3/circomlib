# `MultiAND(n)`

## Description

This template performs an `n`-input [AND gate](https://en.wikipedia.org/wiki/AND_gate). 

## Schema

```
             _______________     
            |               |
in[n] ----> |  MultiAND(n)  | ----> out
            |_______________|     
```

## Dependencies

```
include "../../../comparators/is_zero/is_zero.circom";
```

## Expected Inputs

| Input      | Type                  |
| -----      | -----                 | 
| `in[n]`    | Array of `n` booleans |

## Outputs

| Output  | Type     | Description               |
| ------  | ------   | ----------      | 
| `out`   | Boolean  | `out = in[0] ∧ ... ∧ in[n-1]`. |

## Benchmarks 

## Test