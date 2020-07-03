# `GreaterEqThan(n)`

## Description

This template compares two field elements and returns `1` if the first input is greater or equal than the second, and `0` otherwise.

## Schema

```
             ____________________     
            |                    |
in[2] ----> |  GreaterEqThan(n)  | ----> out
            |____________________|     
```

## Dependencies

```
include "../less_than/less_than.circom";
```

## Expected Inputs

| Input           | Type           |
| -------------   | -------------  | 
| `in[2]`         | Array of 2 field elements of `n` bits each |

<!-- TODO: The MSF is the sign bit. -->

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out`         | Boolean        | `out = 1` if `in[0]` is greater or equal than `in[1]`, and `out = 0` otherwise.|

## Benchmarks 

## Test