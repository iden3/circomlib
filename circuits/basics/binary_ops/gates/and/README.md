# `AND()`

## Description

This template performs the [AND gate](https://en.wikipedia.org/wiki/AND_gate) (or logical conjunction). 

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

```
Number of Wires: 4
Number of Constraints: 1
Number of Private Inputs: 0
Number of Public Inputs: 2
Number of Outputs: 1
```