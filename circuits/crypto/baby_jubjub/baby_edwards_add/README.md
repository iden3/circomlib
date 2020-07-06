# `BabyEdwardsAdd()`

## Background

The arithmetic performed here is based on this [article](https://eprint.iacr.org/2008/013.pdf).

## Description

This template adds two points on the [Baby Jubjub curve](https://github.com/ethereum/EIPs/pull/2494) in twisted Edwards form. More specifically, given two points P1 = (`x1`, `y1`) and P2 = (`x2`, `y2`) it returns a point P3 = (`xout`, `yout`)  such that

(`xout`, `yout`) =  (`x1`,`y1`) + (`x2`,`y2`) 
        = ((`x1y2`+`y1x2`)/(1+`dx1x2y1y2`)),(`y1y2`-`ax1x2`)/(1-`dx1x2y1y2`))

## Schema

```
             var a     var d
               |         |
               |         |
           ____v_________v_____     
x1 ---->  |                    |
y1 ---->  |  BabyEdwardsAdd()  | ----> xout
x2 ---->  |                    | ----> yout
y2 ---->  |____________________|     
```

## Dependencies

None.

## Expected Inputs

| Input         | Type           | Description         |                                            
| ------------- | -------------  | -------------       | 
| `x1`          | Field element  | First coordinate of a point `(x1, y1)` on twisted Edwards Baby Jubjub curve.  |
| `y1`          | Field element  | Second coordinate of a point `(x1, y1)` on twisted Edwards Baby Jubjub curve.  |
| `x2`          | Field element  | First coordinate of a point `(x2, y2)` on twisted Edwards Baby Jubjub curve.  |
| `y2`          | Field element  | Second coordinate of a point `(x2, y2)` on twisted Edwards Baby Jubjub curve.  |

**Requirement**: at least `x1 != x2` or `y1 != y2`.


## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `xout`        | Field element  | First coordinate of the addition point `(xout, yout) = (x1, y1) + (x2, y2)` on twisted Edwards Baby Jubjub curve. |
| `yout`        | Field element  | Second coordinate of the doubling point `(xout, yout) = (x1, y1) + (x2, y2)` on twisted Edwards Baby Jubjub curve. |

## Benchmarks 

## Test