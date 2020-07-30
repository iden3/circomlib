# `Num2Bits(n)`

## Description

This template converts a field element `in` to its binary representation `out[n]`. 
TODO: It may overflow, it does not check it out!

## Schema

```
          _______________     
         |               |
in ----> |  Num2Bits(n)  | ----> out[n]
         |_______________|     
```

## Dependencies

None.


## Expected Input

| Input           | Type           |
| -------------   | -------------  | 
| `in`            | Field element  |

## Outputs

| Output           | Type                     | Description     |
| -------------    | -------------            | ----------      | 
| `out[n]`         | Binary array of `n` bits | Binary representation of the field element `in` using the [LSB 0 bit numbering](https://en.wikipedia.org/wiki/Bit_numbering#LSB_0_bit_numbering) encoding. |

## Benchmarks 

## Test

template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1=0;

    var e2=1;
    for (var i = 0; i<n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * e2;
        e2 = e2+e2;
    }

    lc1 === in;
}