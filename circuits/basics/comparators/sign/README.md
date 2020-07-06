# `Sign()` 

## Description

This template returns the sign of an input. 
A number is considered to be **positive** if and only if it is less or equal than `(q-1)/2`, where 
```
q = 21888242871839275222246405745257275088548364400416034343698204186575808495617
```
is the prime order of `altbn128`, the pairing-friendly elliptic curve used to verify zk-SNARK proofs in Ethereum. 
<!-- TODO: Add REF to curve altbn128-->

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
| `in[254]`         | Field element of 254 bits |

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `sign`        | Boolean        | </p>If `in` is positive (i.e. less or equal than `(q-1)/2`), then `sign = 0`.<br>Otherwise, `in` is negative and `sign = 1`.</p> |

## Benchmarks 

## Test