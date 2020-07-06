# `BabyEdwardsBits2Point_strict()`

## Description

This template recieves a binary number of 256 bits, checks that such number is less than `r` and returns a point on Baby Jubjub twisted Edwards curve. ... TODO: Add strict desc!.

## Schema

```
               __________________________________     
              |                                  |
in[256] ----> |  BabyEdwardsBits2Point_strict()  | ----> out[2]
              |__________________________________|     
```

## Dependencies

None.

## Expected Inputs

| Input         | Type                     |
| ------------- | -------------            |
| `in[256]`     | Binary array of 256 bits |

## Outputs

| Output        | Type                          | Description         |
| ------------- | -------------                 | -------------       | 
| `out[2]`      | Array of 2 field elements     | Coordinates `(x,y)` of a point on Baby Jubjub twisted Edwards curve.|


## Benchmarks 

## Test