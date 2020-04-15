# `NOR()`

## Description

This template performs the [NOR gate](https://en.wikipedia.org/wiki/NOR_gate) (or logical nor). 
<!-- Output true if and only if both inputs are false -->

## Schema

```
         _________     
a ----> |         |
        |  NOR()  | ----> out
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
| `out`   | Boolean  | `out = ¬(a v b)`. |

## Benchmarks 

## Test