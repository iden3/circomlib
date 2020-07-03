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
| `out`         | Boolean | </p>If `in[0] > in[1]`, then `out = 1`.<br>If `in[1] =< in[0]`, then `out = 0`.</p> |

## Benchmarks 

## Test