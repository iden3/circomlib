# `Num2Bits(n)`

## Description

This template converts a field element (i.e. is there a max of bits)? `in` to its binary representation `out[n]`.

## Schema

```
          _____________________     
         |                     |
in ----> |     Num2Bits(n)     | ----> out[n]
         |_____________________|     
```

## Dependencies

None.

## Inputs

 signal input in;
    signal output out[n];

The input `in` is a (field element?) of ? bits.
    signal output out[n];

## Outputs

The output `out[n]` is an array of `n` binary numbers representing a binary number.
<!--- TODO: Add the order of the representation, i.e. out0] vs. out[n-1] -->
## Benchmarks 

## Test