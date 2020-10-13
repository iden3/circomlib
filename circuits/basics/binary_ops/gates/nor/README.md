# `NOR()`

## Description

This template performs the [NOR gate](https://en.wikipedia.org/wiki/NOR_gate) (or logical nor). 

## Schema

```
         _________     
a ----> |         |
        |  NOR()  | ----> out
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
| `out`   | Boolean  | `out = ¬(a v b)`. |

## Benchmarks 

```
Number of Wires: 4
Number of Constraints: 1
Number of Private Inputs: 0
Number of Public Inputs: 2
Number of Outputs: 1
```