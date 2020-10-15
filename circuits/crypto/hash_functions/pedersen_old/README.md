# `Pedersen(n)` (Old Version)

- `calcpedersenbases`: set of functions in JavaScript used to find a set of points in [Baby Jubjub](https://github.com/barryWhiteHat/baby_jubjub) elliptic curve that serve as basis for the [Pedersen Hash](https://github.com/zcash/zcash/issues/2234).


## Description

This template returns the [Pedersen hash](https://github.com/iden3/circomlib/tree/organization/doc/pedersen_hash.md) of a given sequence of bits. 

<!--
    The Zcash designers introduced a new 256-bit hash functioncalled Pedersen hash [28, p.134], which is effectively a vectorized Pedersen com-mitment in elliptic curve groups with short vector elements. For the claimed128-bit security level, it utilizes 869 constraints per 516-bit message chunks,thus having 1.7 constraints per bit, whereas ourPoseidoninstances use from0.2 to 0.45 constraints per bit, depending on the underlying prime field. [Poseidon]
-->

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

## Expected Inputs

| Input         | Type                      |
| ------------- | -------------             |
| `in[n]`       | Binary array of `n` bits  |

TODO: No és amb bits?? (Mirar el test!)

## Outputs

| Output        | Type                          | Description         |      
| ------------- | -------------                 | -------------       | 
| `out[2]`      | Array with two field elements | The output `out = H(in)` are the `x` and `y` coordinates of a point on the large prime subgroup of [Baby Jubjub](https://github.com/ethereum/EIPs/pull/2494) elliptic curve. More specifically, such point is `(x,y) = (out[0], out[1])`. |

## Benchmarks 

With `n = 500`:
```
Number of Wires: 1997
Number of Constraints: 1496
Number of Private Inputs: 0
Number of Public Inputs: 500
Number of Outputs: 2
```