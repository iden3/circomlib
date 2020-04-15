# `Bits2Num_strict()`

## Description

This template converts a binary number `in[n]` of `n` bits to its
integer representation STRICT 

<!--- TODO: Add strict description. -->

## Schema

```
             _____________________     
            |                     |
in[n] ----> |  Bits2Num_strict()  | ----> out
            |_____________________|     
```


## Dependencies

```
include "../../aliascheck/aliascheck.circom";
include "../bits2num/bits2num.circom";
```

## Inputs

| Input              | Type                      | Representation             |
| -------------      | -------------             | -------------      | 
| `in[n]`            | Binary array of `n` bits  |  The encoding is considered with the [LSB 0 bit numbering](https://en.wikipedia.org/wiki/Bit_numbering#LSB_0_bit_numbering). |

## Outputs

| Output           | Type          | Description     |
| -------------    | ------------- | ----------      | 
| `out`            | Field element | Integer representation of the binary number `in[n]`.  |

## Benchmarks 

## Test