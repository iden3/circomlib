# `MultiMux3(n)`
<!-- TODO: Fill in -->

## Description

This template ... .

## Schema

```
               ________________     
   s[3] ----> |                |
              |  MultiMux3(n)  | ----> out[n]
c[n][8] ----> |________________|     
```

## Dependencies

None.

## Expected Inputs

| Input           | Type           |
| -------------   | -------------  | 
| `s[3]`          | (Selector)     |
| `c[n][8]`       |                |


## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out[n]`      |                |          |

## Benchmarks 

With `n = 32`:
```
Number of Wires: 485
Number of Constraints: 225
Number of Private Inputs: 0
Number of Public Inputs: 259
Number of Outputs: 32
```

With `n = 254`:
```
Number of Wires: 3815
Number of Constraints: 1779
Number of Private Inputs: 0
Number of Public Inputs: 2035
Number of Outputs: 254
```