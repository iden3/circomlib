# `BinSum(n, ops)`

**TODO / Comments**

Similar to binsum: something wired with aux: text spec =/= constraints and computation (check!).

## Description

This component performs a binary sum of any amount of binary numbers of `n` bits each. 
It consists of a function and a template:
- The function `nbits(a)` calculates the number of extra bits that the output needs in order to do the full sum.
- The template `BinSum(n, ops)` computes the binary sum.

<!--
Binary Sum

This component creates a binary sum componet of ops operands and n bits each operand.

e is Number of carries: Depends on the number of operands in the input.

Main Constraint:
   in[0][0]     * 2^0  +  in[0][1]     * 2^1  + ..... + in[0][n-1]    * 2^(n-1)  +
 + in[1][0]     * 2^0  +  in[1][1]     * 2^1  + ..... + in[1][n-1]    * 2^(n-1)  +
 + ..
 + in[ops-1][0] * 2^0  +  in[ops-1][1] * 2^1  + ..... + in[ops-1][n-1] * 2^(n-1)  +
 ===
   out[0] * 2^0  + out[1] * 2^1 +   + out[n+e-1] *2(n+e-1)

To waranty binary outputs:

    out[0]     * (out[0] - 1) === 0
    out[1]     * (out[0] - 1) === 0
    .
    .
    .
    out[n+e-1] * (out[n+e-1] - 1) == 0
 -->

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

## Inputs

| Input              | Type                                               |
| -------------      | -------------                                  | 
| `in[ops][n]`       | An array of `ops` binary arrays of `n` bits each.  |

## Outputs

| Output           | Type               | Description               |
| -------------    | -------------                | ----------      | 
| `out[nout]`      | Binary array of `nout` bits  | Binary sum of all the `n`-bit operands in `in[ops]`. |

## Benchmarks 

## Test