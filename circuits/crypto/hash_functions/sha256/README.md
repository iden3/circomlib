# `Sha256(nBits)`

## Description

This template returns the hash SHA256 of an input of arbitrary length. 

## Background and structure 

The template `sha256.circom` has been implemented following the main loop described in the following [document](http://www.iwar.org.uk/comsec/resources/cipher/sha256-384-512.pdf) (page 5). In there, one can find all the specifications of the SHA256 hash function and of the following subroutines:

- `_ch` : logical function ch (page 6).
- `_constants` : initial hash value H(0) (page 3) and sequence of constant words K (page 7).
- `_maj.circom` : logical function Maj (page 6).
- `_rotate` : right shift (page 2).
- `_sha256compression` : compression function (page 8).
- `_shift` : right rotation (page 2).
- `_sigma_plus` : TODO: Jordi? (binary addition of sigmas? as in page 8?).
- `_sigma` : logical functions Σ and σ (page 6).
- `_t1` : function in the main loop (page 5).
- `_t2` : function in the main loop (page 5).
- `_xor3` : logical function XOR of 3 elements (page 2).

## Schema

TODO: Make it a bit better...

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