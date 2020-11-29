# `Sha256(nBits)`

## Description

This template returns the hash SHA-256 of an input of arbitrary length. 

## Background

This is a general overview of how SHA-256 hash function works given any input message `M` of `n` bits:

1. Pad `M` with its length in such a way that the result is a multiple of 512 bits long.
2. Parse `M` into 512-bit message blocks `M_1,M_2,...,M_N`.
3. Process each message block one at a time: begin with a fixed initial hash value `H_0` and sequentially compute
    ```
    H_i = H_{i+1} + C_{M_i}( H_{i-1} )
    ```
   The function `C` is called the SHA-256 compression function and `+` is the word-wise `mod 232` addition. 
4. The hash of `M` is `H_N`.

## Implementation 

The template `sha256.circom` has been implemented following the description from the NIST of [SHA-256](https://web.archive.org/web/20130526224224/http://csrc.nist.gov/groups/STM/cavp/documents/shs/sha256-384-512.pdf). In this document, one can find all technicalities of SHA-256 hash function (page 5) and specifics of the following internal templates:

- `_ch` : logical function `Ch` (page 6).
- `_constants` : initial hash value `H_0` (page 3) and sequence of constant words `K_0,...,K_63` (page 7).
- `_maj.circom` : logical function `Maj` (page 6).
- `_rotate` : right shift `R_n` (page 2).
- `_sha256compression` : compression function `C` (page 8).
- `_shift` : right rotation `S_n` (page 2).
- `_sigma_plus` : addition of sigmas (page 8).
- `_sigma` : logical functions `Σ_{1,2}` and `σ_{1,2}` (page 6).
- `_t1` : function `T1` in the main loop (page 5).
- `_t2` : function `T2` in the main loop (page 5).
- `_xor3` : logical function `XOR` of 3 elements (page 2).

## Schema

```
                 _________________     
                |                 |
in[nBits] ----> |  Sha256(nBits)  | ----> out[256]
                |_________________|     
```

## Dependencies

```
include "_constants.circom";
include "_sha256compression.circom";
```
Internally, it also requires
```
include "_ch.circom"
include "_constants.circom";
include "_maj.circom"
include "_rotate.circom";
include "_shift.circom";
include "_sigma_plus.circom";
include "_sigma.circom"
include "_t1.circom";
include "_t2.circom";
include "_xor3.circom";
include "../../../basics/binary_ops/bin_sum/bin_sum.circom";
```

## Expected Inputs

| Input         | Type                          |
| ------------- | -------------                 | 
| `in[nBits]`   | Binary array of `nBits` bits  | 

## Outputs

| Output         | Type           | Description         |
| -------------  | -------------  | -------------       |
| `out[256]`     | Binary array of 256 bits | SHA-256 hash of the input `in`. |

## Benchmarks 

With `nBits = 448`:
```
Number of Wires: 59452
Number of Constraints: 59051
Number of Private Inputs: 0
Number of Public Inputs: 448
Number of Outputs: 256
```

With `nBits = 512`:
```
Number of Wires: 59682
Number of Constraints: 59281
Number of Private Inputs: 0
Number of Public Inputs: 512
Number of Outputs: 256
```