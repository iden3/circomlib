# `IsZero()` 

## Description

This template checks if the input `in` is the field element zero. 

## Schema

```
          ____________     
         |            |
in ----> |  IsZero()  | ----> out
         |____________|     
```

## Dependencies

None.

## Expected Inputs

| Input           | Type           |
| -------------   | -------------  | 
| `in`            | Field element  |


## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out`         | Boolean        | `out = 1` if `in = 0` and `out = 0` if `in != 0`.|

## Benchmarks 

## Test