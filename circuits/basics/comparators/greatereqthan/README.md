# `GreaterEqThan(n)`

TODO: The MSF is the sign bit.

## Description

This template compares two inputs (field elements?) and returns 0 if the first is greater or equal than the second and 1 otherwise.

## Schema

```
             ____________________     
            |                    |
in[2] ----> |  GreaterEqThan(n)  | ----> out
            |____________________|     
```

## Dependencies

```
include "../lessthan/lessthan.circom";
```

## Inputs

-  `in[2]`: an array of 2 inputs? of `n` bits each.

## Outputs

A boolean `out`:
- `out = 0` if `in[0]` is greater or equal than `in[1]`.
- `out = 1` if `in[0]` is less than `in[1]`.

## Benchmarks 

## Test