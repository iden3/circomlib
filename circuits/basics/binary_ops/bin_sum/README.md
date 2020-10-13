# `BinSum(n, ops)`

## Description

This tempalte performs a binary sum of any amount of binary numbers of `n` bits each. It template makes use
of an external function `nbits(a)` that calculates the number of extra bits that the output needs in order to do the full sum. 

## Schema

```           
               nout = nbits((2^n-1)*ops)
                          |
                  ________v_________             
                 |                  |            
in[ops][n] ----> |  BinSum(n, ops)  | ----> out[nout]
                 |__________________|     
```

## Dependencies

None. 

## Expected Inputs

| Input              | Type                                               |
| -------------      | -------------                                      | 
| `in[ops][n]`       | An array of `ops` binary arrays of `n` bits each.  |

## Outputs

| Output           | Type                         | Description                                          |
| -------------    | -------------                | ----------                                           | 
| `out[nout]`      | Binary array of `nout` bits  | Binary sum of all the `n`-bit operands in `in[ops]`. |

## Benchmarks 

With `n = 32` and `ops = 2`:
```
Number of Wires: 98
Number of Constraints: 34
Number of Private Inputs: 0
Number of Public Inputs: 64
Number of Outputs: 33
```

With `n = 254` and `ops = 8`:
```
Number of Wires: 2034
Number of Constraints: 1
Number of Private Inputs: 0
Number of Public Inputs: 2032
Number of Outputs: 1
```