# `MontgomeryAdd()`

## Background

The arithmetic performed here is based on wikipedia webpage on [Montgomery elliptic curves](https://en.wikipedia.org/wiki/Montgomery_curve). (TODO: Add link to arithmetic on research-notes).

<!--               1 + y       1 + y
    [u, v] = [ -------  , ---------- ]
                1 - y      (1 - y)x

 -->

## Description

This templates adds two points on the [Baby Jubjub curve](https://github.com/barryWhiteHat/baby_jubjub) in Montgomery form. More specifically, given two **different** points P1 = (`x1`, `y1`) and P2 = (`x2`, `y2`) it returns a point P3 = (`xout`, `yout`)  such that (TODO: Change formula!)

(`xout`, `yout`) =  (`x1`,`y1`) + (`x2`,`y2`) 
        = ((`x1y2`+`y1x2`)/(1+`dx1x2y1y2`)),(`y1y2`-`ax1x2`)/(1-`dx1x2y1y2`))

## Schema

```
                                var a     var d
                                   |         |
                                   |         |
                             ______v_________v__     
            input x1 ---->  |                   |
            input y1 ---->  |  MontgomeryAdd()  | ----> output xout
            input x2 ---->  |                   | ----> output yout
            input y2 ---->  |___________________|     
```

## Dependencies

None.

## Inputs

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