# `MultiMux4(n)`
<!-- TODO: Fill in -->

## Description

This template ... .

## Schema

```
                ________________     
    s[4] ----> |                |
               |  MultiMux4(n)  | ----> out[n]
c[n][16] ----> |________________|     
```

## Dependencies

None.

## Expected Inputs

| Input           | Type           |
| -------------   | -------------  | 
| `s[4]`          | (Selector)     |
| `c[n][16]`       |                |


## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out[n]`      |                |          |

## Benchmarks 

With `n = 32`:
```
Number of Wires: 1001
Number of Constraints: 484
Number of Private Inputs: 0
Number of Public Inputs: 516
Number of Outputs: 32
```

With `n = 254`:
```
Number of Wires: 7883
Number of Constraints: 3814
Number of Private Inputs: 0
Number of Public Inputs: 4068
Number of Outputs: 254
```