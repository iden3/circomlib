# `MultiMux1(n)`
<!-- TODO: Fill in -->

## Description

This template receives a boolean `s` and a matrix `c[n][2]` of `n` rows and `2` columns. Depending on the value of the selector `s`, the template outputs either the first or the second column of the matrix.
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
| `s`             | Boolean        | Selector    |
| `c[n][2]`       | `n` arrays of 2 TODO:bits??               | 

## Outputs

| Output        | Type           | Description     |
| ------------- | -------------  | ----------      | 
| `out[n]`      | Array of `n` (TODO: bits?) | </p>If `s=0`, then `out[i] = c[i][0]` for all `i=1...n`.<br>If `s=1`, then `out[i] = c[i][1]` for all `i=1...n`.</p>           |

## Benchmarks 

With `n = 32`:
```
Number of Wires: 98
Number of Constraints: 32
Number of Private Inputs: 0
Number of Public Inputs: 65
Number of Outputs: 32
```

With `n = 254`:
```
Number of Wires: 764
Number of Constraints: 254
Number of Private Inputs: 0
Number of Public Inputs: 509
Number of Outputs: 254
```