# `BabyEdwards2Montgomery()`

## Description

This template converts a point on twisted Edwards Baby Jubjub curve to its Montgomery form. It uses the birational map... TODO: Fill in with the formula! 

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
| `in[2]`       | Array of two field elements  | TODO: Add!  |

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out[2]`      | Array of 2 field elements  | TODO: coordinates `(x, y)` of the point ... ! |

## Benchmarks 

```
Number of Wires: 5
Number of Constraints: 2
Number of Private Inputs: 0
Number of Public Inputs: 2
Number of Outputs: 2
```