# `NAND()`

## Description

This template performs the [NAND gate](https://en.wikipedia.org/wiki/NAND_gate). 
<!-- Output which is false if and only if all its inputs are true -->

## Schema

```
         __________     
a ----> |          |
        |  NAND()  | ----> out
b ----> |__________|     
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
| `out`   | Boolean  | `out = ¬(a ∧ b)`. |

## Benchmarks 

## Test