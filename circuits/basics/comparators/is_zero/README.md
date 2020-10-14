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
| `out`         | Boolean        | </p>If `in = 0`, then `out = 1`.<br>If `in != 0`, then `out = 0`.</p>|

## Benchmarks 

```
Number of Wires: 4
Number of Constraints: 2
Number of Private Inputs: 0
Number of Public Inputs: 1
Number of Outputs: 1
```