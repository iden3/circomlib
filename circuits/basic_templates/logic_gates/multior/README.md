# `MultiOR(n)`

## Description

This template performs an `n`-input [OR gate](https://en.wikipedia.org/wiki/OR_gate). 
<!-- Out is true if and only if at least one of the operands is true -->

## Schema

```
             ______________     
            |              |
in[n] ----> |  MultiOR(n)  | ----> out
            |______________|     
```

## Dependencies

```
include "../or/or.circom";
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