# `MontgomeryDbl()`

## Background

The arithmetic performed here is based on wikipedia webpage on [Montgomery elliptic curves](https://en.wikipedia.org/wiki/Montgomery_curve). (TODO: Add link to arithmetic on research-notes).

<!--               1 + y       1 + y
    [u, v] = [ -------  , ---------- ]
                1 - y      (1 - y)x

 -->

## Description

This templates adds two points on the [Baby Jubjub curve](https://github.com/ethereum/EIPs/pull/2494) in Montgomery form. More specifically, given two **different** points P1 = (`x1`, `y1`) and P2 = (`x2`, `y2`) it returns a point P3 = (`xout`, `yout`)  such that (TODO: Change formula!)

(`xout`, `yout`) =  (`x1`,`y1`) + (`x2`,`y2`) 
        = ((`x1y2`+`y1x2`)/(1+`dx1x2y1y2`)),(`y1y2`-`ax1x2`)/(1-`dx1x2y1y2`))

## Schema

```
             ___________________     
            |                   |  
in[2] ----> |  MontgomeryDbl()  | ----> out[2]
            |___________________|     
```

## Dependencies

None.

## Expected Inputs

| Input         | Type           | Description         |                                            
| ------------- | -------------  | -------------       | 
| `in[2]`       | Array of 2 field elements  | Coordinates `(x, y)` of a point on Montgomery Baby Jubjub curve. More precisely, `in[0] = x` and `in[1] = y`.  |

TODO: Also different from O?

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out[2]`      | Array of 2 field elements  | Coordinates `(x, y)` of the doubling point `(x, y) = 2 * (in[0], in[1])` on Montgomery Baby Jubjub curve. More precisely, `out[0] = x` and `out[1] = y`. |

## Benchmarks 

```
Number of Wires: 7
Number of Constraints: 4
Number of Private Inputs: 0
Number of Public Inputs: 2
Number of Outputs: 2
```