# `MontgomeryAdd()`

## Description

This templates adds two points on the [Baby Jubjub curve](https://github.com/barryWhiteHat/baby_jubjub) in Montgomery form. More specifically, given two **different** points P1 = (`x1`, `y1`) and P2 = (`x2`, `y2`) it returns a point P3 = (`xout`, `yout`)  such that 

(`xout`, `yout`) =  (`x1`,`y1`) + (`x2`,`y2`) 
        = ( `B` * `lambda`^2 - `A` - `x1` - `x2`, `lambda` * ( `x1` - `x3` ) - `y1`)

where `A = 168698`, `B = 1` and `lambda` = (`y2` - `y1`) / (`x2` - `x1`).
 

## Schema

```
             var A    var B
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