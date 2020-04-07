# `BinSub(n)`

**TODO / Comments**

Similar to binsum: something wired with aux: text spec =/= constraints and computation (check!).

## Description

It performs a binary substraction of any two binary numbers of `n` bits.

<!--

This component creates a binary substraction.

Main Constraint:
   (in[0][0]     * 2^0  +  in[0][1]     * 2^1  + ..... + in[0][n-1]    * 2^(n-1))  +
 +  2^n
 - (in[1][0]     * 2^0  +  in[1][1]     * 2^1  + ..... + in[1][n-1]    * 2^(n-1))
 ===
   out[0] * 2^0  + out[1] * 2^1 +   + out[n-1] *2^(n-1) + aux


    out[0]     * (out[0] - 1) === 0
    out[1]     * (out[0] - 1) === 0
    .
    .
    .
    out[n-1]   * (out[n-1] - 1) === 0
    aux * (aux-1) == 0

-->

## Schema

```
                _____________     
               |             |
in[2][n] ----> |  BinSub(n)  | ----> out[n]
               |_____________|     
```

## Dependencies

None. 

## Inputs

| Input              | Type                                 |
| -------------      | -------------                    | 
| `in[2][n]`         | Two binary arrays of `n` bits    |


## Outputs

| Output           | Type               | Description               |
| -------------    | -------------                | ----------      | 
| `out[n]`      | Binary array of `n` bits  | Binary substraction of the `n` bit arrays `in[0] - in[1]` |

## Benchmarks 

## Test