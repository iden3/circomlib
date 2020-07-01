# `ForceEqualIfEnabled()`

## Description

If the input signal `enabled` is different than 0, this template imposes a constraint to ensure that two field elements are equal. If `enabled = 0`, then the constraint is always satisfied, regardless of whether the other two inputs are equal or not.

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

| Input             | Type                        |
| -------------     | -------------               | 
| `enabled`         | Boolean                     | <!-- Although it does work with any number -->
| `in[2]`           | Array of two field elements |

## Outputs

There is no output.

## Benchmarks 

## Test