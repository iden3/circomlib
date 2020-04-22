# `AND()`

## Description

This template performs the [AND gate](https://en.wikipedia.org/wiki/AND_gate) (or logical conjunction). 
<!-- Out is true if and only if all of its operands are true -->

## Schema

```
         _________     
a ----> |         |
        |  AND()  | ----> out
b ----> |_________|     
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
| `out`   | Boolean  | `out = a ∧ b`. |

## Benchmarks 

## Test