# `IsEqual()` 

## Description

This template checks if two field elements are equal.
<!-- It does so by substracting the inputs and checking if the result is zero. -->

## Schema

```
             _____________     
            |             |
in[2] ----> |  IsEqual()  | ----> out
            |_____________|     
```

## Dependencies

```
include "../is_zero/is_zero.circom";
```

## Expected Inputs

| Input           | Type           |
| -------------   | -------------  | 
| `in[2]`         | Array of 2 field elements of `n` bits each |

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out`         | Boolean        | </p>If `in[0] = in[1]`, then `out = 1`.<br>If `in[0] != in[1]`, then  `out = 0`.</p>|

## Benchmarks 

```
Number of Wires: 5
Number of Constraints: 2
Number of Private Inputs: 0
Number of Public Inputs: 2
Number of Outputs: 1
```