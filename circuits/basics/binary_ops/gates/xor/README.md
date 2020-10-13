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

## Expected Inputs

| Input  | Type    |
| -----  | -----   | 
| `a`    | Boolean |
| `b`    | Boolean |

## Outputs

| Output  | Type     | Description               |
| ------  | ------   | ----------      | 
| `out`   | Boolean  | `out = a ⊕ b`. |

## Benchmarks 

```
Number of Wires: 4
Number of Constraints: 1
Number of Private Inputs: 0
Number of Public Inputs: 2
Number of Outputs: 1
```