# `Pedersen(n)`

## Description

This template returns the [Pedersen hash](https://github.com/iden3/research/blob/master/documentation/PedersenHash.md) of a given sequence of bits. 

## Schema

```
              ______________     
             |              |
in[n] ---->  |  Pedersen()  | ----> out[2]
             |______________|     
```

## Dependencies

```
include "../../../elliptic_curves/baby_jubjub/edwards/babyadd/babyadd.circom"
include "segment/segment.circom";
include "window4/window4.circom";
```

## Inputs

| Input         | Type                      |
| ------------- | -------------             |
| `in[n]`       | Binary array of `n` bits  |

TODO: No és amb bits?? (Mirar el test!)

## Outputs

| Output        | Type                          | Description         |      
| ------------- | -------------                 | -------------       | 
| `out[2]`      | Array with two field elements | The output `out = H(in)` are the `x` and `y` coordinates of a point on the large prime subgroup of [Baby Jubjub](https://github.com/ethereum/EIPs/pull/2494) elliptic curve. More specifically, such point is `(x,y) = (out[0], out[1])`. |

## Benchmarks 

## Test