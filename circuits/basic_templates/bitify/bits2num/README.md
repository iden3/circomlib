# `Bits2Num(n)`

## Description

This template converts a binary number `in[n]` of `n` bits to its
integer representation by performing
```
out = sum_{k=0}^{n-1} (in[k] * 2^k).
```

## Schema

```
             ______________________     
            |                      |
in[n] ----> |      Bits2Num(n)     | ----> out
            |______________________|     
```


## Dependencies

None.

## Inputs

The input `in[n]` is an array of `n` binary numbers.

## Outputs

The output `out` is an integer TODO: (a field element?).

## Benchmarks 

## Test