# `Mux1()`
<!-- TODO: Fill in -->

## Description

This template receives a boolean `s` and an array of 2 values. Depending on the selector `s`, the template outputs either the first or the second value of the array.
<!-- multiplexor = data selector : device that selects between several analog or digital input signals and forwards it to a single output line -->

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
| `c[2]`          |                |


## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out`         |                | </p>If `s=0`, then `out = c[0]`.<br>If `s=1`, then `out = c[1]`.</p> |

## Benchmarks 

## Test