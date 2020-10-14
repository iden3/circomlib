# `BabyEdwardsPoint2Bits()`

## Description

This template ... . TODO: Fill in

## Schema

```
             ___________________________     
            |                           |
in[2] ----> |  BabyEdwardsPoint2Bits()  | ----> out[256]
            |___________________________|     
```

## Dependencies

```
include "../../../basics/bitify/num2bits/num2bits.circom";
include "../../../basics/comparators/comp_constant/comp_constant.circom";
```

## Expected Inputs

| Input         | Type                     |
| ------------- | -------------            |
| `in[2]`       | Blabla                   |

## Outputs

| Output        | Type                     | Description         |
| ------------- | -------------            | -------------       | 
| `out[256]`    | Binary array of 256 bits | TODO              |


<!--
out[254] <== 0;
out[255] <== signCalc.out;
-->

## Benchmarks 

```
Number of Wires: 772
Number of Constraints: 771
Number of Private Inputs: 0
Number of Public Inputs: 2
Number of Outputs: 256
```