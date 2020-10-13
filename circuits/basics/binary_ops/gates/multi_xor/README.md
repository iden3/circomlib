# `MultiXOR(n)`

## Description

This template performs an `n`-input [XOR gate](https://en.wikipedia.org/wiki/XOR_gate). 

## Schema

```
             _______________     
            |               |
in[n] ----> |  MultiXOR(n)  | ----> out
            |_______________|     
```

## Dependencies

```
include "../../../bitify/num2bits/num2bits.circom";
```

## Expected Inputs

| Input      | Type                  |
| -----      | -----                 | 
| `in[n]`    | Array of `n` booleans |

## Outputs

| Output  | Type     | Description     |
| ------  | ------   | ----------      | 
| `out`   | Boolean  | `out = in[0] ⊕ ... ⊕ in[n-1]`. |

## Benchmarks 

With `n = 5`:
```
Number of Wires: 10
Number of Constraints: 5
Number of Private Inputs: 0
Number of Public Inputs: 5
Number of Outputs: 1
```

With `n = 1024`:
```
Number of Wires: 2048
Number of Constraints: 1024
Number of Private Inputs: 0
Number of Public Inputs: 1024
Number of Outputs: 1
```