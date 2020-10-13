# `BinSub(n)`

## Description

This template performs a binary substraction of any two binary numbers of `n` bits. 

## Schema

```
                _____________     
               |             |
in[2][n] ----> |  BinSub(n)  | ----> out[n]
               |_____________|     
```

## Dependencies

None. 

## Expected Inputs

| Input              | Type                           |
| -------------      | -------------                  | 
| `in[2][n]`         | Two binary arrays of `n` bits  |

## Outputs

| Output        | Type                      | Description     |
| ------------- | -------------             | ----------      | 
| `out[n]`      | Binary array of `n` bits  | Binary substraction of the `n`-bit arrays `in[0] - in[1]`. |

## Benchmarks 

With `n = 16`:
```
Number of Wires: 49
Number of Constraints: 17
Number of Private Inputs: 0
Number of Public Inputs: 32
Number of Outputs: 16
```

With `n = 254`:
```
Number of Wires: 763
Number of Constraints: 255
Number of Private Inputs: 0
Number of Public Inputs: 508
Number of Outputs: 254
```