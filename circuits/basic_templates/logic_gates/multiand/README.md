# `MultiAND(n)`

## Description

This template performs an `n`-input [AND gate](https://en.wikipedia.org/wiki/AND_gate). 
<!-- Out is true if and only if all of its operands are true -->

## Schema

```
             _______________     
            |               |
in[n] ----> |  MultiAND(n)  | ----> out
            |_______________|     
```

## Dependencies

```
include "../and/and.circom";
```

## Inputs

| Input      | Type                  |
| -----      | -----                 | 
| `in[n]`    | Array of `n` booleans |

## Outputs

| Output  | Type     | Description               |
| ------  | ------   | ----------      | 
| `out`   | Boolean  | `out = in[0] ∧ ... ∧ in[n-1]`. |

## Benchmarks 

## Test