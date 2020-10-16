# `MiMCSponge(nInputs, nRounds, nOutputs)`

## Description

This template implements the [MiMC-2n/n](https://eprint.iacr.org/2016/492.pdf) (or Feistel-MiMC) hash function using a sponge construction.

## Schema

```
                    _________________________________________     
ins[nInputs] ----> |                                         |
                   |  MiMCSonge(nInputs, nRounds, nOutputs)  | ----> outs[nOutputs]
           k ----> |_________________________________________|     
```

## Dependencies

```
include "_mimc_feistel.circom"
```

## Expected Inputs

| Input          | Type                            | 
| -------------  | -------------                   |
| `ins[nInputs]` | Array of `nInputs` field elements |
| `k`            | Field element                   |

## Output

| Input            | Type           |
| -------------    | -------------  |  
| `outs[nOutputs]` | Array of `nOutputs` field elements | 

## Benchmarks 

With `nInputs = 2`, `nRounds = 220` and `nOutputs = 3`:
```
Number of Wires: 2644
Number of Constraints: 2640
Number of Private Inputs: 0
Number of Public Inputs: 3
Number of Outputs: 3
```