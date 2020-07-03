# `Switcher()` 

## Description

This template receives two inputs `L` and `R` and, depending on a third boolean input `sel`, it returns the same two values but either in the same channel or switched.  

## Schema

```
           ______________ 
  L ----> |              | ----> outL
sel ----> |  Switcher()  | 
  R ----> |______________| ----> outR    
```

## Dependencies

```
include "../compconstant/compconstant.circom";
```

## Expected Inputs

| Input         | Type           |

| ------------- | -------------  | 
| `sel`         | Boolean      |
| `R`           | Field element (any representation: binary, decimal...) |
| `L`           | Field element (any representation: binary, decimal...) |

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `outR`        | If `sel == 0`, then `outR` has the same type as input `R`. If `sel == 1`, then `outR` has the same type as input `L` | If `sel == 0`, then `outR = R`. If `sel == 1`, then `outR = L`. |
| `outL`        | If `sel == 0`, then `outL` has the same type as input `L`. If `sel == 1`, then `outL` has the same type as input `R` | If `sel == 0`, then `outL = L`. If `sel == 1`, then `outL = R`. |

| column 1 | column 2 |
|------------|----------|
| value | <ul><li>value 1</li><li>value 2</li></ul> |
| value | <ul><li>value 1</li><li>value 2</li></ul> |

## Benchmarks 

## Test