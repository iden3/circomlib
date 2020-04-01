# `BabyDbl()`

// Extracts the public key from private key
template BabyPbk() {
    signal private input  in;
    signal         output Ax;
    signal         output Ay;

    var BASE8[2] = [
        5299619240641551281634865583518297030282874472190772894086521144482721001553,
        16950150798460657717958625567821834550301663161624707787222815936182638968203
    ];

    component pvkBits = Num2Bits(253);
    pvkBits.in <== in;

    component mulFix = EscalarMulFix(253, BASE8);

    var i;
    for (i=0; i<253; i++) {
        mulFix.e[i] <== pvkBits.out[i];
    }
    Ax  <== mulFix.out[0];
    Ay  <== mulFix.out[1];
}


## Description

This templates extracte from a private key a public key on [Baby Jubjub curve](https://github.com/barryWhiteHat/baby_jubjub). More specifically, given an input `in`, it returns the point (`Ax`, `Ay`) = `in`*BASE8, where BASE8 is a base point, generator of .... . in twisted Edwards form!

## Schema

```
               ________________________     
              |                        | ----> output Ax
input in ---->|       BabyPbk()        | 
              |________________________| ----> output Ay
```

## Dependencies

```
include "../babyadd/babyadd.circom";
```

## Inputs

| Input         | Representation | Description         |                                             |
| ------------- | -------------  | -------------       | -------------                               |
| `x`          | Bigint         | Field element of Fp | First coordinate of a point (x, y) on E on twisted Edwards form.  |
| `y`          | Bigint         | Field element of Fp | Second coordinate of a point (x, y) on E on twisted Edwards form. |

## Outputs

| Output         | Representation | Description         |                                             |
| ------------- | -------------  | -------------       | -------------                               |
| `xout`          | Bigint         | Field element of Fp | First coordinate of the doubling point (xout, yout) = 2(x, y).  |
| `yout`          | Bigint         | Field element of Fp | Second coordinate of the doubling point (xout, yout) = 2(x, y). |


## Benchmarks 

## Test