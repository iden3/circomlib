# `BabyEdwards2Montgomery()`

## Description

This template converts a point on twisted Edwards Baby Jubjub curve to its Montgomery form. It uses the birational map:
```
(x, y) --> (u, v)

u = (1+y)/(1-y) 
v = (1+y)/((1-y)x)
```

## Schema

```
             ___________________________     
            |                           |
in[2] ----> |  BabyEdwards2Montgomery() | ----> out[2]
            |___________________________|
```

## Dependencies

None.

## Expected Inputs

| Input         | Type           | Description         |                                            
| ------------- | -------------  | -------------       | 
| `in[2]`       | Array of 2 field elements  | Coordinates `(x, y)` of a point on twisted Edwards Baby Jubjub curve. More precisely, `in[0] = x` and `in[1] = y`.  |

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out[2]`      | Array of 2 field elements  | Coordinates `(u, v)` of the point `(x, y)` in Montgomery form. More precisely, `out[0] = u` and `out[1] = v`. |

## Benchmarks 

```
Number of Wires: 5
Number of Constraints: 2
Number of Private Inputs: 0
Number of Public Inputs: 2
Number of Outputs: 2
```