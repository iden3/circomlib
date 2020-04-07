# `Num2Bits_strict()`

## Description

This template converts a field element (i.e. is there a max of bits)? `in` to its binary representation `out[254]`.
integer representation STRICT

## Schema

```
          _____________________     
         |                     |
in ----> |  Num2Bits_strict()  | ----> out[254]
         |_____________________|     
```


## Dependencies

```
include "../../aliascheck/aliascheck.circom";
include "../num2bits/num2bits.circom"```
```

## Inputs

signal input in;
signal output out[254];

The input `in` is a .

## Outputs

The output `out[254]` is an array of 254 binary numbers.
<!--- TODO: Add the order of the representation, i.e. out[0] vs. out[253] -->

## Benchmarks 

## Test