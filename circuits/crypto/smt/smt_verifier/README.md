# `SMTVerifier(nLevels)`

## Description

This template ... 

## Schema

```
                 _________________________     
input x1 ---->  |                         |
input y1 ---->  |  SMTProcessor(nLevels)  | ----> output xout
input y2 ---->  |_________________________|     
```

## Dependencies

None.

## Expected Inputs

| Input         | Representation | Description         |                                             |
| ------------- | -------------  | -------------       | -------------                               |
| `x1`          | Bigint         | Field element of Fp | First coordinate of a point (x1, y1) on E.  |
| `y1`          | Bigint         | Field element of Fp | Second coordinate of a point (x1, y1) on E. |

## Outputs

| Output          | Representation | Description         |           
| -------------   | -------------  | -------------       | 
| `xout`          | Bigint         | Field element of Fp | 


## Benchmarks 

With `nLevels = 10`:
```
Number of Wires: 4793
Number of Constraints: 4784
Number of Private Inputs: 0
Number of Public Inputs: 18
Number of Outputs: 0
```