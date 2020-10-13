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

```
Number of Wires: 4
Number of Constraints: 1
Number of Private Inputs: 0
Number of Public Inputs: 2
Number of Outputs: 1
```