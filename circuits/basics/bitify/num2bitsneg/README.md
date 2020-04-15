# `Num2BitsNeg(n)`

## Description

TODO: This template converts a ... 

## Schema

```
          ____________________     
         |                    |
in ----> |   Num2BitsNeg(n)   | ----> out[n]
         |____________________|     
```

## Dependencies

```
include "../../comparators/iszero/iszero.circom";
```

    signal input in;
    signal output out[n];

## Inputs

| Input           | Type           |
| -------------   | -------------  | 
| `in`            | Field element  |

## Outputs

| Output           | Type                     | Description     |
| -------------    | -------------            | ----------      | 
| `out[n]`         | Binary array of `n` bits | Binary representation of the field element `in`. The encoding used is the [LSB 0 bit numbering](https://en.wikipedia.org/wiki/Bit_numbering#LSB_0_bit_numbering) scheme. TODO: ADD THE NEG PART. |

## Benchmarks 

## Test