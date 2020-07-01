# `Sign()` 

## Description

This template returns the sign of an input. 
A number is considered to be positive if and only if it is TODO: less or equal? than `(q-1)/2` with
```
q = 21888242871839275222246405745257275088548364400416034343698204186575808495617
```
the prime order of altbn128, the curve used to verify zk-SNARK proofs in Ethereum.
TODO: Add link to the curve and so on.

## Schema

```
               __________ 
              |          |
in[254] ----> |  Sign()  | ----> sign
              |__________|     
```

## Dependencies

```
include "../compconstant/compconstant.circom";
```

## Expected Inputs

| Input             | Type           |
| -------------     | -------------  | 
| `in[254]`         | TODO:Fill      |


## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `sign`        | Boolean        | `sign = 0` if `in` is positive and `sign = 1` otherwise. TODO: Sure? |

## Benchmarks 

## Test