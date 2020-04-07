# `AliasCheck()`

Link to template:
https://github.com/iden3/circomlib/tree/master/circuits/basics/aliascheck/aliascheck.circom

**TODO / Comments**
1. There is **no output**!
2. Adds an equality constraint on the output signal of a component template.
3. Since does not return anythig has === without assignment.
4. Needs an assert to say input signals are binary?

## Description

The template checks if an input expanded to binary array `in` overflowed its 254 bits (<= -1).

## Schema

```
                    ________________     
                   |                |
input in[254] ---->|  AliasCheck()  |
                   |________________|     
```

## Dependencies

```
include "../compconstant/compconstant.circom";
```

## Inputs

A binary array of 254 bits. 

## Outputs

**There is no output!**

## Benchmarks 

## Test