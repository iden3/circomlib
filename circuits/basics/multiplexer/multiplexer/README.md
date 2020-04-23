# `Multiplexer(wIn, nIn)`

## Description

This template ... .

It makes use of two (internal?) sub?templates/routines? :
- [`_decoder`](decoder)
- [`_scalarproduct`](scalarproduct)

## Schema

```
                     _________________________     
          sel ----> |                         |
                    |  Multiplexer(wIn, nIn)  | ----> out[wIn]
inp[nIn][wIn] ----> |_________________________|     
```

## Dependencies

None.

## Expected Inputs

| Input           | Type           |
| -------------   | -------------  | 
| `sel`           | (Selector)     |
| `inp[nIn][wIn]` |                |


## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out[wIn]`    |                |          |

## Benchmarks 

## Test