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
include "../less_than/less_than.circom";
```

// n is the number of bits of the input.
// The MSF is the sign bit.

## Inputs

-  `in[2]`: an array of 2 inputs? of `n` bits each.

| Input           | Type           |
| -------------   | -------------  | 
| `in[2]`         | Array of 2 field elements? |


## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out`         | Boolean | `out = 0` if `in[0]` is greater or equal than `in[1]` and `out = 1` otherwise.|

## Benchmarks 

## Test