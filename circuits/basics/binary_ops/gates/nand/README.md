# `NAND()`

## Description

This template performs the [NAND gate](https://en.wikipedia.org/wiki/NAND_gate). 

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