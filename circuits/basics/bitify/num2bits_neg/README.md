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
include "../../comparators/is_zero/is_zero.circom";
```

    signal input in;
    signal output out[n];

## Expected Inputs

| Input           | Type           |
| -------------   | -------------  | 
| `in`            | Field element  |

## Outputs

| Output           | Type                     | Description     |
| -------------    | -------------            | ----------      | 
| `out[n]`         | Binary array of `n` bits | Binary representation of the field element `in` using the [LSB 0 bit numbering](https://en.wikipedia.org/wiki/Bit_numbering#LSB_0_bit_numbering) encoding. TODO: ADD THE NEG PART. |

## Benchmarks 

With `n = 32`:
```
Number of Wires: 35
Number of Constraints: 34
Number of Private Inputs: 0
Number of Public Inputs: 1
Number of Outputs: 32
```

With `n = 254`:
```
Number of Wires: 257
Number of Constraints: 256
Number of Private Inputs: 0
Number of Public Inputs: 1
Number of Outputs: 254
```