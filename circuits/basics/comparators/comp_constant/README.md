# `CompConstant(ct)`

## Description

This template checks if a binary input `in` is greater than a given constant `ct`.

## Schema

```
               ____________________     
              |                    |
in[254] ----> |  CompConstant(ct)  | ----> out
              |____________________|     
```

## Dependencies

```
include "../../bitify/num2bits/num2bits.circom";
```

## Expected Inputs

| Input             | Type           |
| -------------     | -------------  | 
| `in[254]`         | Binary array of `254` bits |

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out`         | Boolean        | </p>If `in > ct`, then `out = 1`.<br>If `in =< ct`, then `out = 0`.</p> |

## Benchmarks 

With `ct = 12574899965841125748859665329478411236025236211254788521259648301247745896`:
```
Number of Wires: 516
Number of Constraints: 262
Number of Private Inputs: 0
Number of Public Inputs: 254
Number of Outputs: 1
```
