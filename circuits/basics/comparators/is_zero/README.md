# `IsZero()` 

## Description

This template checks if the input `in` is zero. 
(it does by checking if the input has an inverse or not. As working in a field element, the only element with no inverse is the zero).

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

-  `in`: a field element??.

## Outputs

A boolean `out`:
- `out = 0` if `in != 0`.
- `out = 1` if `in = 0`.

## Benchmarks 

## Test