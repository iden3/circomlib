# `Sha256(nBits)`

## Description

This template returns the hash SHA256 of an input of arbitrary length. 

## Background

This is a general overview of how SHA256 hash function works: given any input message `M` of `n` bits, first:

1. Pad it with its length in such a way that the result is a multiple of 512 bits long.
2. Parse it into 512-bit message blocks `M_1`,`M_2`,...,`M_N`.

The message blocks are processed one at a time: beginning with a fixed initial hash value `H_0`, sequentially compute
```
H_i = H_{i+1} + C_{M_i} (H_{i-1})
```
where `C` is the SHA-256 compression function and `+` means word-wise `mod 232` addition. The hash of `M` is the final `H_N`.

## Files structure 

The template `sha256.circom` has been implemented following the main loop described in the following [document](http://www.iwar.org.uk/comsec/resources/cipher/sha256-384-512.pdf) (page 5). In there, one can find all the specifications of the SHA256 hash function and of the following subroutines:

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