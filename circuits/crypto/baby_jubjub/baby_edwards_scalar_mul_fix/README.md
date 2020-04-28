# `BabyEdwardsScalarMulFix()`

## Background

The arithmetic performed here is based on this [article](https://eprint.iacr.org/2008/013.pdf).

## Description

This template multiplies ... 

## Schema

```
                   var a     var d
                     |         |
                     |         |
                 ____v_________v_____     
input x1 ---->  |                    |
input y1 ---->  |  BabyEdwardsAdd()  | ----> output xout
input x2 ---->  |                    | ----> output yout
input y2 ---->  |____________________|     
```

## Dependencies

None.

## Expected Inputs

| Input         | Representation | Description         |                                             |
| ------------- | -------------  | -------------       | -------------                               |
| `x1`          | Bigint         | Field element of Fp | First coordinate of a point (x1, y1) on E.  |
| `y1`          | Bigint         | Field element of Fp | Second coordinate of a point (x1, y1) on E. |
| `x2`          | Bigint         | Field element of Fp | First coordinate of a point (x2, y2) on E.  |
| `y2`          | Bigint         | Field element of Fp | Second coordinate of a point (x2, y2) on E. |

Requirement: at least `x1`!=`x2` or `y1`!=`y2`.

## Outputs

| Output         | Representation | Description         |                                             |
| ------------- | -------------  | -------------       | -------------                               |
| `xout`          | Bigint         | Field element of Fp | First coordinate of the addition point (xout, yout) = (x1, y1) + (x2, y2).  |
| `yout`          | Bigint         | Field element of Fp | Second coordinate of the addition point (xout, yout) = (x1, y1) + (x2, y2). |


## Benchmarks 

## Test