# `IsEqual()` 

## Description

This template checks if two inputs (field elements?) are equal. (It substracts the inputs and checks if it is zero.)

## Schema

```
             _____________     
            |             |
in[2] ----> |  IsEqual()  | ----> out
            |_____________|     
```

## Dependencies

```
include "../iszero/iszero.circom";
```

## Inputs

-  `in[2]`: an array of 2 inputs? of `n` bits each (n is nowhere)??? field elements?

## Outputs

A boolean `out`: (same logic as isZero)
- `out = 0` if `in[0] != in[1]`.
- `out = 1` if `in[0] = in[1]`.

## Benchmarks 

## Test