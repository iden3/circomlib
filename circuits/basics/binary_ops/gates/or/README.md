# `OR()`

## Description

This template performs the [OR gate](https://en.wikipedia.org/wiki/OR_gate) (or logical disjunction). 
<!-- Out is true if and only if at least one of its operands is true -->

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

| Output  | Type     | Description               |
| ------  | ------   | ----------      | 
| `out`   | Boolean  | `out = a v b`. |

## Benchmarks 

## Test