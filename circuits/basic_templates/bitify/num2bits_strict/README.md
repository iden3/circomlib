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

| Input           | Type           |
| -------------   | -------------  | 
| `in`            | Field element  |

## Outputs

| Output           | Type                     | Description     |
| -------------    | -------------            | ----------      | 
| `out[254]`         | Binary array of `254` bits | Binary representation of the field element `in`. The encoding is done using the [LSB 0 bit numbering](https://en.wikipedia.org/wiki/Bit_numbering#LSB_0_bit_numbering) scheme. |

## Benchmarks 

## Test