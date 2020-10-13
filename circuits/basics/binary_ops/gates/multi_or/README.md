# `MultiOR(n)`

## Description

This template performs an `n`-input [OR gate](https://en.wikipedia.org/wiki/OR_gate). 

## Schema

```
             ______________     
            |              |
in[n] ----> |  MultiOR(n)  | ----> out
            |______________|     
```

## Dependencies

```
include "../../../comparators/is_zero/is_zero.circom";
```

## Expected Inputs

| Input      | Type                  |
| -----      | -----                 | 
| `in[n]`    | Array of `n` booleans |

## Outputs

| Output  | Type     | Description               |
| ------  | ------   | ----------      | 
| `out`   | Boolean  | `out = in[0] v ... v in[n-1]`. |

## Benchmarks 

With `n = 5`:
```
Number of Wires: 8
Number of Constraints: 2
Number of Private Inputs: 0
Number of Public Inputs: 5
Number of Outputs: 1
```

With `n = 1024`:
```
Number of Wires: 1027
Number of Constraints: 2
Number of Private Inputs: 0
Number of Public Inputs: 1024
Number of Outputs: 1
```