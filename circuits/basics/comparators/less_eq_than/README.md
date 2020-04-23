# `LessEqThan(n)` 

## Description

This template compares two inputs (field elements?) and returns 0 if the first is less or equal than the second and 1 otherwise.

## Schema

```
             _________________     
            |                 |
in[2] ----> |  LessEqThan(n)  | ----> out
            |_________________|     
```

## Dependencies

```
include "../lessthan/lessthan.circom";
``` 

## Expected Inputs

-  `in[2]`: an array of 2 inputs? of `n` bits each.

## Outputs

A boolean `out`:
- `out = 0` if `in[0]` is less or equal than `in[1]`.
- `out = 1` if `in[0]` is greater than `in[1]`.

## Benchmarks 

## Test