# `LessThan(n)` 

## Description

This template compares two field elements and returns `1` if the first is less than the second and `0` otherwise. 
<!-- It does so by converting the inputs to binary and comparing the bits. -->

## Schema

```
             _______________     
            |               |
in[2] ----> |  LessThan(n)  | ----> out
            |_______________|     
```

## Dependencies

```
include "../../bitify/num2bits/num2bits.circom";
``` 

## Expected Inputs

| Input           | Type           |
| -------------   | -------------  | 
| `in[2]`         | Array of 2 field elements of `n` bits each |

<!-- TODO: // The MSF is the sign bit. -->

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out`         | Boolean        | </p>If `in[0] < in[1]`, then `out = 1`.<br>If `in[0] >= in[1]`, then `out = 0`.</p>|

## Benchmarks 

## Test