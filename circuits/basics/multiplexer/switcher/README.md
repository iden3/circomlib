# `Switcher()` 

## Description

This template receives two inputs `L` and `R` and, depending on a third boolean input `sel`, it returns the two inputs in their same channel or switched.

## Schema

```
           ______________ 
  L ----> |              | ----> outL
sel ----> |  Switcher()  | 
  R ----> |______________| ----> outR    
```

## Dependencies

None.

## Expected Inputs

| Input         | Type           |
| ------------- | -------------  | 
| `sel`         | Boolean      |
| `R`           | Field element (any representation: binary, decimal...) |
| `L`           | Field element (any representation: binary, decimal...) |

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `outR`        | <p>If `sel == 0`, then `outR` has the same type as input `R`<br>If `sel == 1`, then `outR` has the same type as input `L`</p> | </p>If `sel == 0`, then `outR = R`.<br>If `sel == 1`, then `outR = L`.</p> |
| `outL`        | </p>If `sel == 0`, then `outL` has the same type as input `L`<br>If `sel == 1`, then `outL` has the same type as input `R`</p> | </p>If `sel == 0`, then `outL = L`.<br>If `sel == 1`, then `outL = R`.</p> |

## Benchmarks 

## Test