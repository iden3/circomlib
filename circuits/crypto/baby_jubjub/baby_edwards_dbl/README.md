# `BabyEdwardsDbl()`

## Description

This templates double a point on the [Baby Jubjub curve](https://github.com/ethereum/EIPs/pull/2494) in twisted Edwards form. More specifically, given a point P = (`x`, `y`) it returns a point Q = (`xout`, `yout`)  such that

(`xout`, `yout`) =  (`x`,`y`) + (`x`,`y`)
        = ((2`x``y`)/(1+``d``x`^2`y`^2`)),(`y^2`-`ax^2`)/(1-`dx^2y^2`))

## Schema

```
         ____________________     
x ----> |                    | ----> xout
        |  BabyEdwardsDbl()  | 
y ----> |____________________| ----> yout
```

## Dependencies

```
include "../baby_edwards_add/baby_edwards_add.circom";
```

## Expected Inputs

| Input           | Type           | Description    |
| -------------   | -------------  | -------------  |
| `x`             | Field element  | First coordinate of a point `(x, y)` on twisted Edwards Baby Jubjub curve.  |
| `y`             | Field element  | Second coordinate of a point `(x, y)` on twisted Edwards Baby Jubjub curve. |

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `xout`        | Field element  | First coordinate of the doubling point `(xout, yout) = 2 * (x, y)` on twisted Edwards Baby Jubjub curve. |
| `yout`        | Field element  | Second coordinate of the doubling point `(xout, yout) = 2 * (x, y)` on twisted Edwards Baby Jubjub curve. |

## Benchmarks 

```
Number of Wires: 9
Number of Constraints: 6
Number of Private Inputs: 0
Number of Public Inputs: 2
Number of Outputs: 2
```