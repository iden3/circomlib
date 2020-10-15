# `MiMCSponge(nInputs, nRounds, nOutputs)`

## Description

This template ... .

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

| Input          | Type           | Description   |
| -------------  | -------------  | ------------- | 
| `ins[nInputs]` | ...            | ...   | 
| `k`            | ...            | ... | 

## Output

| Input            | Type           | Description   |
| -------------    | -------------  | ------------- | 
| `outs[nOutputs]` | ...            | ...   | 

## Benchmarks 

With `nInputs = 2`, `nRounds = 220` and `nOutputs = 3`:
```
Number of Wires: 2644
Number of Constraints: 2640
Number of Private Inputs: 0
Number of Public Inputs: 3
Number of Outputs: 3
```