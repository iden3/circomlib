# `NOT()`

## Description

This template performs the [NOT gate](https://en.wikipedia.org/wiki/NOT_gate) (or logical negation). 

## Schema

```
          _________     
         |         |
in ----> |  NOT()  | ----> out
         |_________|     
```

## Dependencies

None.

## Expected Input

| Input   | Type    |
| -----   | -----   | 
| `in`    | Boolean |

## Outputs

| Output  | Type     | Description               |
| ------  | ------   | ----------      | 
| `out`   | Boolean  | `out = ¬(in)`. |

## Benchmarks 

```
Number of Wires: 3
Number of Constraints: 1
Number of Private Inputs: 0
Number of Public Inputs: 1
Number of Outputs: 1
```