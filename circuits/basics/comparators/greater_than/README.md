# `GreaterThan(n)`

TODO: The MSF is the sign bit.

## Description

This template compares two inputs (field elements?) and returns 0 if the first is greater than the second and 1 otherwise.

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
| `in[2]`         | TODO: Array of 2 field elements? of `n` bits each? |


## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out`         | Boolean | `out = 0` if `in[0]` is greater than `in[1]` and `out = 1` otherwise.|

## Benchmarks 

## Test