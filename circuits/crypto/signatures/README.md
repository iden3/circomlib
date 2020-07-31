# Digital Signatures

This folder contains templates to verify [EdDSA](https://en.wikipedia.org/wiki/EdDSA) signatures on Baby Jubjub with different hash functions.

## Structure

- [`eddsa_pedersen`](eddsa)
- [`eddsa_mimc_sponge`](eddsa_mimc_sponge)
- [`eddsa_poseidon`](eddsa_poseidon)

## EdDSA on Baby Jubjub 

The Edwards Digital Signature Algorithm (EdDSA) is a variant of Schnorr's signature system with (possibly twisted) Edwards curves that allows using smaller public keys and signatures, providing high performance on a variety of platforms [[1]](https://tools.ietf.org/html/rfc8032). The EdDSA signature scheme needs to be instatiated with certain parameters and consists of two procedures: a generation and a verification algorithm. 

Following [[2]](http://ed25519.cr.yp.to/eddsa-20150704.pdf), we describe below how verification on EdDSA works on [Baby Jubjub](https://github.com/ethereum/EIPs/pull/2494/files) twisted Edwards elliptic curve and how we implemented its logic as an arithmetic circuit using circom.

### Parameters

- **Elliptic curve**: We consider `E` the Baby Jubjub twisted Edwards curve. This curve is defined over the finite field `F_r` where `r` is the prime
    ```
    21888242871839275222246405745257275088548364400416034343698204186575808495617
    ```
    Baby Jubjub has order `8*l` where `l` is the prime
    ```
    2736030358979909402780800718157159386076813972158567259200215660948447373041
    ```
    The base point `B = (x, y)` with coordinates 
    ```
    (5299619240641551281634865583518297030282874472190772894086521144482721001553,
    16950150798460657717958625567821834550301663161624707787222815936182638968203)
    ```
    is a generator of the large prime subgroup of `E` of order `l`.

- **Public key**: Let the public key `A = (Ax, Ay)` be a point on Baby Jubjub of order `l`. Typically, the private key associated to `A` is an integer `k` in the range `[1,...,r-1]` such that `A = k*B`.

- **Message**: Let `M` be a message to sign.

- **Hash function**: We represent the hash function with the letter `H`. We have implemented EdDSA on Baby Jubjub with three different hash functions: [MiMC](https://eprint.iacr.org/2016/492.pdf), [Pedersen](https://github.com/zcash/zips/blob/master/protocol/sapling.pdf) and [Poseidon](https://www.poseidon-hash.info/).

### Signature

The signature on `M` by `A` consists of a par `(R, S)` where:
- `R = (R_x, R_y)` is a point of order `l` of `E`.
- `S` is a number between `1` and `l-1` that satisfies the relation `8*S*B = 8*R + 8*H(R,A,M)*A`.

### Verification

The verification of the signature `(R, S)` on `M` by `A` consists on three checks:
- The parameter `S` is on the range `[1,...,l-1]`.
- The equation `8*S*B = 8*R + 8*H(R,A,M)*A` is satisfied.
- Both sides of the equation result in a point of Baby Jubjub of order `l`. 

### Circuit implementation

The logic of the templates [`eddsa_pedersen`](eddsa), [`eddsa_mimc_sponge`](eddsa_mimc_sponge), [`eddsa_poseidon`](eddsa_poseidon) that verify EdDSA signatures on Baby Jubjub (with Pedersen, MiMC and Posiedon hash functions, respectively) is depicted in the following circuit.

![](https://i.imgur.com/Ejx9Kdd.png)

## References

[[1]](https://tools.ietf.org/html/rfc8032)  S. Josefsson and I. Liusvaara, *Edwards-Curve Digital Signature Algorithm (EdDSA)*, RFC 8032. January 2017.

[[2]](http://ed25519.cr.yp.to/eddsa-20150704.pdf)  D.J. Bernstein, S. Josefsson, T. Lange, P. Schwabe and Bo-Yin Yang, *EdDSA for more curves*. July 2015.