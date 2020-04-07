# `BabyCheck()`

## TODO:

- There is no output!

## Description

This templates checks if two given coordinates `(x,y)` correspond to a point on the [Baby Jubjub curve](https://github.com/barryWhiteHat/baby_jubjub) in twisted Edwards form. More specifically, it checks if `x` and `y` satisfy the quadratic equation 

```
168700 * x^2 + y^2 = 1 + 168696 * x^2 * y^2
```

## Schema

```

               _______________     
input x ----> |               |
              |  BabyCheck()  |
input y ----> |_______________|   
```

## Dependencies

None.

## Inputs

- `x` : bigint (field element of Fp)
- `y` : bigint (field element of Fp)

## Outputs

TODO: There is no output... (it should output 0 or 1)

## Benchmarks 

## Test