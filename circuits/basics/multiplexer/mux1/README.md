# `Mux1()`

## Description

This template receives a boolean `s` and an array of 2 values. Depending on the selector `s`, the template outputs either the first or the second value of the array.

## Schema

```
            __________     
   s ----> |          |
           |  Mux1()  | ----> out
c[2] ----> |__________|     
```

## Dependencies

```
include "../multi_mux1/multi_mux1.circom"
```

## Expected Inputs

| Input           | Type           |
| -------------   | -------------  | 
| `s`             | Boolean        |
| `c[2]`          | Array with 2 field elements  |


## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out`         | Field element  | </p>If `s=0`, then `out = c[0]`.<br>If `s=1`, then `out = c[1]`.</p> |

## Benchmarks 

```
Number of Wires: 5
Number of Constraints: 1
Number of Private Inputs: 0
Number of Public Inputs: 3
Number of Outputs: 1
```