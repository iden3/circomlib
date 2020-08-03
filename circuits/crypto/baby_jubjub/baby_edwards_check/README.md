# `BabyEdwardsCheck()`

## Description

This templates checks if a point with coordinates `(x,y)` is a point on the [Baby Jubjub curve](https://github.com/barryWhiteHat/baby_jubjub) in twisted Edwards form. More specifically, it checks if `x` and `y` satisfy the quadratic equation 

```
168700 * x^2 + y^2 = 1 + 168696 * x^2 * y^2
```

## Schema

```

         ______________________     
x ----> |                      |
        |  BabyEdwardsCheck()  |
y ----> |______________________|   
```

## Dependencies

None.

## Expected Inputs

| Input         | Type          |
| ------------- | ------------- |
| `x`           | Field element |
| `y`           | Field element |

## Outputs

There is no output.

## Benchmarks 

## Test