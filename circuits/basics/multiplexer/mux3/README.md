# `Mux3()`
<!-- TODO: Fill in -->

## Description

This template ... .

## Schema

```
            __________     
s[3] ----> |          |
           |  Mux3()  | ----> out
c[8] ----> |__________|     
```

## Dependencies

```
include "../multi_mux3/multi_mux3.circom"
```

## Expected Inputs

| Input           | Type           |
| -------------   | -------------  | 
| `s[3]`          | (Selector)     |
| `c[8]`       |                |

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out`      |                |          |

## Benchmarks 

```
Number of Wires: 20
Number of Constraints: 8
Number of Private Inputs: 0
Number of Public Inputs: 11
Number of Outputs: 1
```