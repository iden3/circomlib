# `Poseidon(nInputs, t, nRoundsF, nRoundsP)`

## Description

This template returns the hash Poseidon of an input of arbitrary length. 

https://eprint.iacr.org/2019/458.pdf
https://www.poseidon-hash.info/

TODO: Why ARK and not ARC (AddRoundConstants)??

## Schema

TODO: Make it a bit more explicit...

```
                       ____________________________________________     
                      |                                            |
inputs[nInputs] ----> |  Poseidon(nInputs, t, nRoundsF, nRoundsP)  | ----> out
                      |____________________________________________|     
```

## Dependencies

```
include "_sigma.circom"
include "_mix.circom"
include "_ark.circom"
```

## Expected Inputs

| Input               | Type                               |
| -------------       | -------------                      | 
| `inputs[nInputs]`   | Array of `nInputs` field elements TODO: ? | 

## Outputs

| Output         | Type           | Description         |
| -------------  | -------------  | -------------       |
| `out`          | ...            | Pedersen hash of ...  |

## Benchmarks 

## Test