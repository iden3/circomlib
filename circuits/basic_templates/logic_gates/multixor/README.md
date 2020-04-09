# `MultiXOR(n)`

## Description

This template performs an `n`-input [XOR gate](https://en.wikipedia.org/wiki/XOR_gate). 
<!-- Output true if and only if an odd number of inputs are true -->

## Schema

```
             _______________     
            |               |
in[n] ----> |  MultiXOR(n)  | ----> out
            |_______________|     
```

## Dependencies

```
include "../../comparators/iszero/iszero.circom";
```

## Inputs

| Input      | Type                  |
| -----      | -----                 | 
| `in[n]`    | Array of `n` booleans |

## Outputs

| Output  | Type     | Description               |
| ------  | ------   | ----------      | 
| `out`   | Boolean  | `out = in[0] v ... v in[n-1]`. |

## Benchmarks 

## Test