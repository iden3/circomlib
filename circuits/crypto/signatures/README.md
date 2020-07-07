# Digital Signatures

This folder contains templates to verify [EdDSA](https://en.wikipedia.org/wiki/EdDSA) signatures on Baby Jubjub with different hash functions.

## Structure

- [`eddsa_pedersen`](eddsa)
- [`eddsa_mimc_sponge`](eddsa_mimc_sponge)
- [`eddsa_poseidon`](eddsa_poseidon)
- [`js`](js)

## Background 

The Edwards Digital Signature Algorithm (EdDSA) is a variant of Schnorr's signature system with (possibly twisted) Edwards curves that allows using smaller public keys and signatures, providing high performance on a variety of platforms [[1]](https://tools.ietf.org/html/rfc8032). The EdDSA signature scheme needs to be instatiated with certain parameters and consists of two procedures: a **generation** and a **verification** algorithm. We describe below how verification on EdDSA works on [Baby Jubjub](https://github.com/ethereum/EIPs/pull/2494/files) twisted Edwards elliptic curve and how its logic can be implemented as an arithmetic circuit using circom.

### EdDSA on Baby Jubjub

- **Elliptic curve**: Let `E` the Baby Jubjub twisted Edwards curve. This curve is defined over the finite field `F_r` where `r` is the prime
    ```
    21888242871839275222246405745257275088548364400416034343698204186575808495617
    ```
    Baby Jubjub has order `8*l` where `l` is the prime
    ```
    2736030358979909402780800718157159386076813972158567259200215660948447373041
    ```
    The base point `B = (x, y)` with coordinates 
    ```
    (5299619240641551281634865583518297030282874472190772894086521144482721001553, 16950150798460657717958625567821834550301663161624707787222815936182638968203)
    ```
    is a generator of the large prime subgroup of `E` of order `l`.

- **Public key**: Consider a public key `A = (Ax, Ay)` consisting on a point on Baby Jubjub of order `l`. 

- **Message**: Let `M` be a message to sign.

- **Signature**: The signature on `M` by `A` consists of a par `(R, S)` where:
    - `R = (R_x, R_y)` is a point of order `l` of `E` 
    - `S` is a number between 1 and `l-1` such that the relation
        ```
        8*S*B = 8*R + 8*H(R,A,M)*A
        ```
        holds. 

- **Message**: Let `M` be a message we wish to sign.

### Parameters

- **Elliptic curve**: We consider `E` the Baby Jubjub twisted Edwards curve. This curve is defined over the finite field `F_p` where `p` is the prime
    ```
    ...
    ```
    Baby Jubjub has order `8*l` where `l` is the prime
    ```
    ...
    ```

- **Public key**: Let `A = (Ax, Ay)` be a point on Baby Jubjub of order `l`.

- **Message**: Let `M` be a message we wish to sign.

- **Hash function**: We have implemented EdDSA on Baby Jubjub with three different hash functions: MiMC, Pedersen and Poseidon. TODO: Add links!

### Signature

The signature on `M` by `A` consists of a par `(R, S)` where:
- `R = (R_x, R_y)` is a point of order `l` of `E` 
- `S` is a number between 1 and `l-1` such that the relation
    ```
    8*S*B = 8*R + 8*H(R,A,M)*A
    ```
    holds. 

### Verification

The verification of the signature consists on checking that the parameter `S` is on the range `(0,...,l)`, that the equation above is satisfied and that the right hand side and the two elements of the left hand side of the equation are points of Baby Jubjub of order `l`.

### Circuit implementation (verification)

All templates share a similar circuit like the following.

![](https://i.imgur.com/Ejx9Kdd.png)

## References

[[1]](https://tools.ietf.org/html/rfc8032)  S. Josefsson and I. Liusvaara, *Edwards-Curve Digital Signature Algorithm (EdDSA)*. RFC 8032, January 2017.

[[2]](http://ed25519.cr.yp.to/eddsa-20150704.pdf)  D.J. Bernstein, S. Josefsson, T. Lange, P. Schwabe and Bo-Yin Yang, *EdDSA for more curves*. July 2015.