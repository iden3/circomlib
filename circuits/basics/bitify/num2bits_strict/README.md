# `Num2Bits_strict()`

## Description

This template converts a field element (i.e. is there a max of bits)? `in` to its binary representation `out[254]`.
The template adds constraints to ensure that the number does not overflow the field characteristic `p`. Read more about this number [here](../../../../README.md).

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


## Expected Inputs

| Input           | Type           |
| -------------   | -------------  | 
| `in`            | Field element  |

## Outputs

| Output           | Type                     | Description     |
| -------------    | -------------            | ----------      | 
| `out[254]`         | Binary array of `254` bits | Binary representation of the field element `in` using the [LSB 0 bit numbering](https://en.wikipedia.org/wiki/Bit_numbering#LSB_0_bit_numbering) encoding. |

## Benchmarks 

```
Number of Wires: 516
Number of Constraints: 517
Number of Private Inputs: 0
Number of Public Inputs: 1
Number of Outputs: 254
```