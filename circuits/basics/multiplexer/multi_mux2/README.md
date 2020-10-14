# `MultiMux2(n)`
<!-- TODO: Fill in -->

## Description

This template ... .

## Schema

```
               ________________     
   s[2] ----> |                |
              |  MultiMux2(n)  | ----> out[n]
c[n][4] ----> |________________|     
```

## Dependencies

None.

## Expected Inputs

| Input           | Type           |
| -------------   | -------------  | 
| `s[2]`          | (Selector)     |
| `c[n][4]`       |                |


## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out[n]`      |                |                 |

## Benchmarks 

With `n = 32`:
```
Number of Wires: 228
Number of Constraints: 97
Number of Private Inputs: 0
Number of Public Inputs: 130
Number of Outputs: 32
```

With `n = 254`:
```
Number of Wires: 1782
Number of Constraints: 763
Number of Private Inputs: 0
Number of Public Inputs: 1018
Number of Outputs: 254
```