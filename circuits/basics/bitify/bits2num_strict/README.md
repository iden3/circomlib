# `Bits2Num_strict()`

## Description

This template converts a binary number `in[n]` of `n` bits to its integer representation by performing
```
out = sum_{k=0}^{n-1} (in[k] * 2^k).
```
The template adds constraints to ensure that the number does not overflow the field characteristic `p`. Read more about this number [here](../../../../README.md).

## Schema

```
             _____________________     
            |                     |
in[n] ----> |  Bits2Num_strict()  | ----> out
            |_____________________|     
```


## Dependencies

```
include "../../comparators/alias_check/alias_check.circom";
include "../bits2num/bits2num.circom";
```

## Expected Inputs

| Input              | Type                      | Representation             |
| -------------      | -------------             | -------------      | 
| `in[254]`            | Binary array of `254` bits  |  The encoding is expected in the [LSB 0 bit numbering](https://en.wikipedia.org/wiki/Bit_numbering#LSB_0_bit_numbering). |

## Outputs

| Output           | Type          | Description     |
| -------------    | ------------- | ----------      | 
| `out`            | Field element | Integer representation of the binary number `in`.  |

## Benchmarks 

```
Number of Wires: 516
Number of Constraints: 263
Number of Private Inputs: 0
Number of Public Inputs: 254
Number of Outputs: 1
```