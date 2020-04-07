# `BinSub(n)`

Link to template:
https://github.com/iden3/circomlib/tree/master/circuits/basics/binary_arithmetic/binsub/binsub.circom

**TODO / Comments**

Similar to binsum: something wired with aux: text spec =/= constraints and computation (check!).

## Description

It performs a binary substraction of two arbitrary binary numbers of size `n`.

## Schema

```
                _______________________     
               |                       |
in[2][n] ----> |       BinSub(n)       | ----> out[n]
               |_______________________|     
```

## Dependencies

None. 

## Inputs

Two binary `n`-arrays:  `in[2][n]`.

## Outputs

A binary `n`-array: `out[n]`.

## Benchmarks 

## Constraints 

TODO: Look at the circuit and add it here?

## Test