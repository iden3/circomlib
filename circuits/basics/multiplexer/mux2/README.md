# `Mux2()`
<!-- TODO: Fill in -->

## Description

This template ... .

## Schema

```
            __________     
s[2] ----> |          |
           |  Mux2()  | ----> out
c[4] ----> |__________|     
```

## Dependencies

```
include "../multi_mux2/multi_mux2.circom"
```

## Expected Inputs

| Input           | Type           |
| -------------   | -------------  | 
| `s[2]`          |  |
| `c[4]`          | Array with 4 field elements |


## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out`      |                |          |

## Benchmarks 

```
Number of Wires: 11
Number of Constraints: 4
Number of Private Inputs: 0
Number of Public Inputs: 6
Number of Outputs: 1
```