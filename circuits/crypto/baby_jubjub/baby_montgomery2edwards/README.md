# `BabyMontgomery2Edwards()`

## Description

This template converts a point on Montgomery Baby Jubjub curve to its twisted Edwards form. It uses the birational map:
```
(u, v) --> (x, y)

x = u/v
y = (u-1)/(u+1)
```

## Schema

```
             ___________________________     
            |                           |
in[2] ----> |  BabyMontgomery2Edwards() | ----> out[2]
            |___________________________|
```

## Dependencies

None.

## Expected Inputs

| Input         | Type           | Description         |                                            
| ------------- | -------------  | -------------       | 
| `in[2]`       | Array of 2 field elements  | Coordinates `(u, v)` of a point on Montgomery Baby Jubjub curve. More precisely, `in[0] = u` and `in[1] = v`.  |

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out[2]`      | Array of 2 field elements  | Coordinates `(x, y)` of the point `(u, v)` in Montgomery form. More precisely, `out[0] = x` and `out[1] = y`. |


## Benchmarks 

```
Number of Wires: 5
Number of Constraints: 2
Number of Private Inputs: 0
Number of Public Inputs: 2
Number of Outputs: 2
```