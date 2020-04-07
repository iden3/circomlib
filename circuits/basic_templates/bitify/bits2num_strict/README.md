# `Bits2Num_strict()`

## Description

This template converts a binary number `in[n]` of `n` bits to its
integer representation STRICT 

<!--- TODO: Add strict description. -->

## Schema

```
             _____________________     
            |                     |
in[n] ----> |  Bits2Num_strict()  | ----> out
            |_____________________|     
```


## Dependencies

```
include "../../aliascheck/aliascheck.circom";
include "../bits2num/bits2num.circom";
```

## Inputs


## Inputs

| Input           | Type                        |
| -------------   | -------------               | 
| `in[n]`         | Binary array of `n` bits    |

## Outputs

| Output           | Type          | Description     |
| -------------    | ------------- | ----------      | 
| `out`            | Field element | Field representation of the binary number `in[n]`  |

## Benchmarks 

## Test