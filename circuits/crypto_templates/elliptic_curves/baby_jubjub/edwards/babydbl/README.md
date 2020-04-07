# `BabyDbl()`

## Description

This templates double a point on the [Baby Jubjub curve](https://github.com/barryWhiteHat/baby_jubjub) in twisted Edwards form. More specifically, given a point P = (`x`, `y`) it returns a point Q = (`xout`, `yout`)  such that

(`xout`, `yout`) =  (`x`,`y`) + (`x`,`y`)
        = ((2`x``y`)/(1+``d``x`^2`y`^2`)),(`y^2`-`ax^2`)/(1-`dx^2y^2`))

## Schema

```
               ________________________     
input x ----> |                        | ----> output xout
              |       BabyDbl()        | 
input y ----> |________________________| ----> output yout
```

## Dependencies

```
include "../babyadd/babyadd.circom";
```

## Inputs

| Input         | Representation | Description         |                                             |
| ------------- | -------------  | -------------       | -------------                               |
| `x`          | Bigint         | Field element of Fp | First coordinate of a point (x, y) on E on twisted Edwards form.  |
| `y`          | Bigint         | Field element of Fp | Second coordinate of a point (x, y) on E on twisted Edwards form. |

## Outputs

| Output         | Representation | Description         |                                             |
| ------------- | -------------  | -------------       | -------------                               |
| `xout`          | Bigint         | Field element of Fp | First coordinate of the doubling point (xout, yout) = 2(x, y).  |
| `yout`          | Bigint         | Field element of Fp | Second coordinate of the doubling point (xout, yout) = 2(x, y). |


## Benchmarks 

## Test