# `MultiOR(n)`

## Description

This template performs an `n`-input [OR gate](https://en.wikipedia.org/wiki/OR_gate). 

## Schema

```
             ______________     
            |              |
in[n] ----> |  MultiOR(n)  | ----> out
            |______________|     
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
| `out`   | Boolean  | `out = in[0] v ... v in[n-1]`. |

## Benchmarks 

## Test