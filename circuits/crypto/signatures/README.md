# `signatures`

This folder contains the templates to generate EdDSA signatures with different hash functions.

## Structure of the Folder

- [`eddsa`](eddsa)
- [`eddsa_mimc`](eddsa_mimc)
- [`eddsa_mimc_sponge`](eddsa_mimc_sponge)
- [`eddsa_poseidon`](eddsa_poseidon)
- [`js`](js)

## Background on Edwards Digital Signature Algorithm on Baby Jubjub

http://ed25519.cr.yp.to/eddsa-20150704.pdf
https://tools.ietf.org/html/rfc8032

It is a variant of Schnorr's signature system with (possibly twisted) Edwards curves.

An EdDSA (Edwards Digital Signature Algorithm) over Baby Jubjub on a message `M` consists
on a public key, ..., ... and .

The **verification** and also **generation** algorithm??

The description of this protocol is based in \cite{eddsa}:  	
Let the public key be a point `A = (Ax, Ay)` in baby Jubjub elliptic curve `E` of order `l` TODO: name of the order??? and let `M` a message we wish to sign. 

The signature on `M` by `A` consists of a par `(R, S)` where `R = (R_x, R_y)` is a point of order `l` of `E` and `S` is a number between 1 (TODO: ??)?? and `l-1` such that 
```
8*S*B = 8*R + 8*H(R,A,M)*A
```

The verification consists on checking that S is on range and 
verifying this equation.

### Sign

The EdDSA signature of a message M under a private key k is defined
as the PureEdDSA signature of PH(M).  In other words, EdDSA simply
uses PureEdDSA to sign PH(M).

The PureEdDSA signature of a message M under a private key k is the
2*b-bit string ENC(R) || ENC(S).  R and S are derived as follows.
First define r = H(h_b || ... || h_(2b-1) || M) interpreting 2*b-bit
strings in little-endian form as integers in {0, 1, ..., 2^(2*b) -
1}.  Let R = [r]B and S = (r + H(ENC(R) || ENC(A) || PH(M)) * s) mod
L.  The s used here is from the previous section.

### Verify

To verify a PureEdDSA signature ENC(R) || ENC(S) on a message M under
a public key ENC(A), proceed as follows.  Parse the inputs so that A
and R are elements of E, and S is a member of the set {0, 1, ...,
L-1}.  Compute h = H(ENC(R) || ENC(A) || M), and check the group
equation [2^c * S] B = 2^c * R + [2^c * h] A in E.  The signature is
rejected if parsing fails (including S being out of range) or if the
group equation does not hold.

EdDSA verification for a message M is defined as PureEdDSA
verification for PH(M).

Let a message M under a public key A, and compte

h = H(R || A || M) and check that [2^c * S] B = 2^c * R + [2^c * h] A in E.

The signature is rejected if parsing fails (including S being out of range) or if the
group equation does not hold.

All templates share a similar circuit (just substitue the HASH FUNCTION box
by te specific hash function: pedersen (default), mimc-7,mimc-7 sponge, poseidon).

### Circuit

![](https://i.imgur.com/Ejx9Kdd.png)