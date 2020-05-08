# `Bits2Num(n)`

## Description

This template converts a binary number `in[n]` of `n` bits to its integer representation by performing
```
out = sum_{k=0}^{n-1} (in[k] * 2^k).
```
The template does not check if the number overflows the field characteristic [`r`] TODO: Add link to this `r`.

## Schema

```
             _______________     
            |               |
in[n] ----> |  Bits2Num(n)  | ----> out
            |_______________|     
```

## Dependencies

None.

## Expected Inputs

| Input              | Type                      | Representation             |
| -------------      | -------------             | -------------      | 
| `in[n]`            | Binary array of `n` bits  | The encoding is expected in the [LSB 0 bit numbering](https://en.wikipedia.org/wiki/Bit_numbering#LSB_0_bit_numbering). |

## Outputs

| Output           | Type          | Description     |
| -------------    | ------------- | ----------      | 
| `out`            | Field element | Integer representation of the binary number `in[n]`.  |

## Benchmarks 

## Test
