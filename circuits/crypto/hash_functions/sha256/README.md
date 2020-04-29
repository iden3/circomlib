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

## Files structure 

The template `sha256.circom` has been implemented following the SHA-256 hash function [description](https://web.archive.org/web/20130526224224/http://csrc.nist.gov/groups/STM/cavp/documents/shs/sha256-384-512.pdf) from NIST. In the document, one can find all technicalities of SHA-256 (page 5) and specifics of the following internal templates:

- `_ch` : logical function `Ch` (page 6).
- `_constants` : initial hash value `H_0` (page 3) and sequence of constant words `K_0,...,K_63` (page 7).
- `_maj.circom` : logical function `Maj` (page 6).
- `_rotate` : right shift `R_n` (page 2).
- `_sha256compression` : compression function `C` (page 8).
- `_shift` : right rotation `S_n` (page 2).
- `_sigma_plus` : TODO: Jordi? (binary addition of sigmas? as in page 8?).
- `_sigma` : logical functions `Σ_{1,2}` and `σ_{1,2}` (page 6).
- `_t1` : function `T1` in the main loop (page 5).
- `_t2` : function `T2` in the main loop (page 5).
- `_xor3` : logical function `XOR` of 3 elements (page 2).

## Schema

TODO: Make it a bit more explicit...

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

## Expected Inputs

| Input         | Type                          |
| ------------- | -------------                 | 
| `in[nBits]`   | Binary array of `nBits` bits  | 

## Outputs

| Output         | Type           | Description         |
| -------------  | -------------  | -------------       |
| `out[256]`     | ...            | ..... |

Binary array of nout bits

## Benchmarks 

## Test