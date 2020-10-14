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
             var a    var d
               |        |
               |        |
           ____v________v_____     
x1 ---->  |                   |
y1 ---->  |                   | ----> xout
          |  MontgomeryAdd()  |
x2 ---->  |                   | ----> yout
y2 ---->  |___________________|     
```

## Dependencies

None.

## Expected Inputs

| Input         | Type           | Description         |                                            
| ------------- | -------------  | -------------       | 
| `x1`          | Field element  | First coordinate of a point `(x1, y1)` on Montgomery Baby Jubjub curve.  |
| `y1`          | Field element  | Second coordinate of a point `(x1, y1)` on Montgomery Baby Jubjub curve.  |
| `x2`          | Field element  | First coordinate of a point `(x2, y2)` on Montgomery Baby Jubjub curve.  |
| `y2`          | Field element  | Second coordinate of a point `(x2, y2)` on Montgomery Baby Jubjub curve.  |

**Requirement**: at least `x1 != x2` or `y1 != y2`.

TODO: Also different from O?

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `xout`        | Field element  | First coordinate of the addition point `(xout, yout) = (x1, y1) + (x2, y2)` on Montgomery Baby Jubjub curve. |
| `yout`        | Field element  | Second coordinate of the doubling point `(xout, yout) = (x1, y1) + (x2, y2)` on Montgomery Baby Jubjub curve. |

## Benchmarks 

```
Number of Wires: 8
Number of Constraints: 3
Number of Private Inputs: 0
Number of Public Inputs: 4
Number of Outputs: 2
```