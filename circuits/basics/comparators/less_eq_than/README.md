# `LessEqThan(n)` 

## Description

This template compares two field elements and returns `1` if the first is less or equal than the second and `0` otherwise.

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

| Input           | Type           |
| -------------   | -------------  | 
| `in[2]`         | Array of 2 field elements of `n` bits each |

<!-- TODO: // The MSF is the sign bit. -->

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out`         | Boolean        | `out = 1` if `in[0] =< in[1]` and `out = 0` if `in[0] > in[1]`.|

## Benchmarks

## Test