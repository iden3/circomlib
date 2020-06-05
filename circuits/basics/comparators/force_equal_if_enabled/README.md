# `ForceEqualIfEnabled()`

## Description

TODO: This template ... .

template ForceEqualIfEnabled() {
    signal input enabled;
    signal input in[2];

    component isz = IsZero();

    in[1] - in[0] ==> isz.in;

    (1 - isz.out)*enabled === 0;
}

## Schema

```
               _________________________     
enabled ----> |                         |
              |  ForceEqualIfEnabled()  |
  in[2] ----> |_________________________|     
```

## Dependencies

```
include "../is_zero/is_zero.circom";
```

## Expected Inputs

| Input             | Type           |
| -------------     | -------------  | 
| `enabled`         | TODO: Fill      |
| `in[2]`           | TODO: Fill      |

## Outputs

There is no output.

## Benchmarks 

## Test