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
| `out`         | Boolean        | </p>If `in[0] =< in[1]`, then `out = 1`.<br>If `in[0] > in[1]`, then `out = 0`.</p>|

## Benchmarks

## Test