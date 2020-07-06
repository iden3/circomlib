# `MultiMux1(n)`
<!-- TODO: Fill in -->

## Description

This template receives a boolean `s` and an `n`-array of 2 values and outputs the first or the second value of all the elements of the array depending on the value of the selector `s`.
<!-- multiplexor = data selector : device that selects between several analog or digital input signals and forwards it to a single output line -->

## Schema

```
               ________________     
      s ----> |                |
              |  MultiMux1(n)  | ----> out[n]
c[n][2] ----> |________________|     
```

## Dependencies

None.

## Expected Inputs

| Input           | Type           | Description |
| -------------   | -------------  | ----------- |
| `s`             | (Selector) TODO: 0 or 1?     | Selector    |
| `c[n][2]`       | `n` arrays of 2 TODO:bits??               | 

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out[n]`      | Array of `n` (TODO: bits?) | </p>If `s=0`, then `out[i] = c[i][0]` for all `i=1...n`.<br>If `s=1`, then `out[i] = c[i][1]` for all `i=1...n`.</p>           |

## Benchmarks 

## Test