# `Num2Bits(n)`

## Description

This template converts a field element `in` to its binary representation `out[n]`. 
The template does not check if the number overflows the field characteristic `p`. Read more about this number [here](../../../../README.md).

## Schema

```
          _______________     
         |               |
in ----> |  Num2Bits(n)  | ----> out[n]
         |_______________|     
```

## Dependencies

None.


## Expected Input

| Input           | Type           |
| -------------   | -------------  | 
| `in`            | Field element  |

## Outputs

| Output           | Type                     | Description     |
| -------------    | -------------            | ----------      | 
| `out[n]`         | Binary array of `n` bits | Binary representation of the field element `in` using the [LSB 0 bit numbering](https://en.wikipedia.org/wiki/Bit_numbering#LSB_0_bit_numbering) encoding. |

## Benchmarks
