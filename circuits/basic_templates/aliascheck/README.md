# `AliasCheck()`

**TODO / Comments**
1. There is **no output**!
2. Adds an equality constraint on the output signal of a component template.
3. Since does not return anythig has === without assignment.
4. Needs an assert to say input signals are binary?
5. Why do you consider overflow `in` <= -1 ?

## Description

The template checks if an input expanded to binary array overflowed its 254 bits (<= -1).

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

| Input              | Type                         |
| -------------      | -------------                | 
| `in[254]`          | Binary array of 245 bits     |

## Outputs

| Output                     |                |
| -------------              | -------------  | 
| ** There is no output!? ** |                |             

## Benchmarks 

## Test