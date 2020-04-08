# `Bits2Num(n)`

TODO: Dir que no té en compte l'overflow, no?

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

| Input              | Type                      | Representation             |
| -------------      | -------------             | -------------      | 
| `in[n]`            | Binary array of `n` bits  | The encoding is considered to be done following the [LSB 0 bit numbering](https://en.wikipedia.org/wiki/Bit_numbering#LSB_0_bit_numbering). |

## Outputs

| Output           | Type          | Description     |
| -------------    | ------------- | ----------      | 
| `out`            | Field element | Integer representation of the binary number `in[n]`.  |

## Benchmarks 

## Test
