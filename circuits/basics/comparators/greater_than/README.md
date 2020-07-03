# `GreaterThan(n)`

## Description

This template compares two field elements and returns `1` if the first is greater than the second, and `0` otherwise.

## Schema

```
             __________________     
            |                  |
in[2] ----> |  GreaterThan(n)  | ----> out
            |__________________|     
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
| `out`         | Boolean | `out = 1` if `in[0]` is greater than `in[1]`, and `out = 0` otherwise.|

## Benchmarks 

## Test