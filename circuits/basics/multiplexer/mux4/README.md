# `Mux4()`
<!-- TODO: Fill in -->

## Description

This template ... .

## Schema

```
             __________     
 s[4] ----> |          |
            |  Mux4()  | ----> out
c[16] ----> |__________|     
```

## Dependencies

```
include "../multi_mux4/multi_mux4.circom"
```

## Expected Inputs

| Input           | Type           |
| -------------   | -------------  | 
| `s[4]`          | (Selector)     |
| `c[16]`         |                |


## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out`         |                |          |

## Benchmarks 

```
Number of Wires: 40
Number of Constraints: 19
Number of Private Inputs: 0
Number of Public Inputs: 20
Number of Outputs: 1
```