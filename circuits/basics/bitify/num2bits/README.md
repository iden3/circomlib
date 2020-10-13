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

With `n = 32`:
```
Number of Wires: 34
Number of Constraints: 33
Number of Private Inputs: 0
Number of Public Inputs: 1
Number of Outputs: 32
```

With `n = 254`:
```
Number of Wires: 256
Number of Constraints: 255
Number of Private Inputs: 0
Number of Public Inputs: 1
Number of Outputs: 254
```
