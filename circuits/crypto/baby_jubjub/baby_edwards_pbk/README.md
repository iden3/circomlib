# `BabyEdwardsPbk()`

## Description

This templates extracts from a private key a public key on [Baby Jubjub curve](https://github.com/ethereum/EIPs/pull/2494). More specifically, given an input `in`, it returns the coordinates of the point 

```
(Ax, Ay) = in*BASE8
``` 
on Baby Jubjub twisted Edwards curve. The point `BASE8` is the generator of the large prime subgroup of Baby Jubjub twisted Edwards elliptic curve and has coordinates
```
BASE8_x = 5299619240641551281634865583518297030282874472190772894086521144482721001553
BASE8_y = 16950150798460657717958625567821834550301663161624707787222815936182638968203
``` 

## Schema

```
          ____________________     
         |                    | ----> Ax
in ----> |  BabyEdwardsPbk()  | 
         |____________________| ----> Ay
```

## Dependencies

```
include "../baby_edwards_scalar_mul_fix/baby_edwards_scalar_mul_fix.circom"; 
include "../../../basics/bitify/num2bits/num2bits.circom";
```

## Expected Inputs

| Input         | Type           | Description         |           
| ------------- | -------------  | -------------       | 
| `in`          | Field element  | Private key of a Baby Jubjub public key. |

**Requirement**: The input `in` should be less than `l`, where
```
l = 2736030358979909402780800718157159386076813972158567259200215660948447373041
```
is the order of the large prime subgroup of Baby Jubjub.

## Outputs

| Output        | Type          | Description         |
| ------------- | ------------- | -------------       |
| `Ax`          | Field element | First coordinate of the Baby Jubjub public key corresponding to the private key `in`, which is  `(Ax, Ay) = in*BASE8`. |
| `Ay`          | Field element | Second coordinate of the Baby Jubjub public key corresponding to the private key `in`, which is  `(Ax, Ay) = in*BASE8`. |


## Benchmarks 

```
Number of Wires: 777
Number of Constraints: 776
Number of Private Inputs: 1
Number of Public Inputs: 0
Number of Outputs: 2
```