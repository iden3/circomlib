# `AliasCheck()`

## Description

The template checks if an input of 254 bits overflowed the prime number `p`, which is 
```
p = 21888242871839275222246405745257275088548364400416034343698204186575808495617
```
This number is the order of BN-254 curve, used to generate and verify zk-SNARK proofs in Ethereum. By default, any signal of a circuit must be in the field `F_p` (i.e. in between `0` and `p-1`). This template helps do this check.

## Schema

```
                    ________________     
                   |                |
input in[254] ---->|  AliasCheck()  |
                   |________________|     
```

## Dependencies

```
include "../comp_constant/comp_constant.circom";
```

## Expected Inputs

| Input              | Type                         |
| -------------      | -------------                | 
| `in[254]`          | Binary array of 245 bits     |

## Outputs

There is no output.

## Benchmarks 

```
Number of Wires: 515
Number of Constraints: 262
Number of Private Inputs: 0
Number of Public Inputs: 254
Number of Outputs: 0
```