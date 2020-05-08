# `MultiXOR(n)`

## Description

This template performs an `n`-input [XOR gate](https://en.wikipedia.org/wiki/XOR_gate). 

## Schema

```
             _______________     
            |               |
in[n] ----> |  MultiXOR(n)  | ----> out
            |_______________|     
```

## Dependencies

```
include "../../../bitify/num2bits/num2bits.circom";
```

## Expected Inputs

| Input      | Type                  |
| -----      | -----                 | 
| `in[n]`    | Array of `n` booleans |

## Outputs

| Output  | Type     | Description     |
| ------  | ------   | ----------      | 
| `out`   | Boolean  | `out = in[0] ⊕ ... ⊕ in[n-1]`. |

## Benchmarks 

## Test