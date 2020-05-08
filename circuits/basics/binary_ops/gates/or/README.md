# `OR()`

## Description

This template performs the [OR gate](https://en.wikipedia.org/wiki/OR_gate) (or logical disjunction). 

## Schema

```
         ________     
a ----> |        |
        |  OR()  | ----> out
b ----> |________|     
```

## Dependencies

None.

## Expected Inputs

| Input  | Type    |
| -----  | -----   | 
| `a`    | Boolean |
| `b`    | Boolean |

## Outputs

| Output  | Type     | Description    |
| ------  | ------   | ----------     | 
| `out`   | Boolean  | `out = a v b`. |

## Benchmarks 

## Test