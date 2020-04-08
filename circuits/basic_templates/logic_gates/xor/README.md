# `XOR()`

## Description

This template performs the [NOR gate](https://en.wikipedia.org/wiki/XOR_gate) (or exclusive or). 
<!-- Output true if and only if an odd number of inputs are true -->
<!-- Output true if and only if exactly one of the inputs is true -->

## Schema

```
         _________     
a ----> |         |
        |  XOR()  | ----> out
b ----> |_________|     
```

## Dependencies

None.

## Inputs

| Input  | Type    |
| -----  | -----   | 
| `a`    | Boolean |
| `b`    | Boolean |

## Outputs

| Output  | Type     | Description               |
| ------  | ------   | ----------      | 
| `out`   | Boolean  | `out = a ⊕ b`. |

## Benchmarks 

## Test