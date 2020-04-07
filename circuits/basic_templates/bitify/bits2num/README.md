# `Bits2Num(n)`

## Description

This template converts a binary number `in[n]` of `n` bits to its
integer representation by performing
```
out = sum_{k=0}^{n-1} (in[k] * 2^k).
```

## Schema

```
             _______________     
            |               |
in[n] ----> |  Bits2Num(n)  | ----> out
            |_______________|     
```

## Dependencies

None.

## Inputs

| Input              | Type                                               |
| -------------      | -------------                                  | 
| `in[n]`            | Binary array of `n` bits  |

## Outputs

| Output           | Type          | Description               |
| -------------    | ------------- | ----------      | 
| `out`            | Field element | Field representation of the binary number `in[n]`  |

## Benchmarks 

## Test
