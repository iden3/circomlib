# Poseidon Hash

## Notation

- `E` is the [Baby Jubjub](https://github.com/ethereum/EIPs/pull/2494) elliptic curve of order `n`.
- `G` is the large prime subgroup of points of Baby Jubjub of order `r`.
- `M` is a sequence of bits of arbitrary length.

## Description

The *Pedersen hash* of a sequence of bits `M` is constructed as follows:

- Split `M` into sequences of at most 186 bits: `M = M_0 M_1 ... M_l`.
- Divide each of these `M_i` sequences into smaller chunks of 3 bits. <!-- (If `M` is not a multiple of 3, pad `M` to a multiple of 3 bits by appending zero bits.) --> More precisely, write 
    ``` 
    M_i = m_0 m_1 ... m_{k_i-1}
    ```
    where each term `m_j` is a chunk of 3 bits `[b_0 b_1 b_2]`. When `i = 0,..., l-1` then `k_i = 62` and for `i = l`, then `k_i <= 62`.

- Encode each chunk `m_j` as an integer from the set `[-4..-1,1..4]` the following way:

    ```
    enc(m_j) = (1+b_0+2*b_1)*(1 - 2*b_2)
    ```
    and let 

    ```
    <M_i> = enc(m_0) + enc(m_1)*2^4 + enc(m_2)*2^8 + ... + enc(m_{k_i-1})*2^{4*(k_i-1)}
    ```

- Let `P_0`,`P_1`,...,`P_k` be uniformly sampled generators of `G` (for some integer `k > l`). 

- We define the Pedersen hash of `M` as 
    ```
    H(M) = <M_0>*P_0 + ... <M_l>*P_l 
    ```

Note that the expression above is a linear combination of elements of `G`, so itself is also an element of `G`. That is, the resulting Pedersen hash `H(M)` is a point of the elliptic curve `E` of order `r`.

## Choice of Generators

We generate the points $P_0,\dots,P_{{k}}$ in such a manner that it is difficult to find a connection between any of these two points. More precisely, we take  D =  "string$\_$seed" followed by a byte S holding that smallest number that H = Keccak256(D || S) results in a point in the elliptic curve $E$.
  
## Circuit implementation

In the circuit **PEDERSEN HASH** depicted in next figure, we described using high-level operation gates the circuit used to compute the Pedersen hash of a message `M`. 

![](https://i.imgur.com/8ccgWJ5.png)

The circuit is designed to compute separetely each term of the sum defining `H(M)` and add all the terms together at the end of the circuit. More precisely, the subcircuit **MULTIPLICATION** takes as input a sequence of bits `M_i` and returns the point `<M_i>*P_i`. Then the sum of all these points is the output of the circuit.

![](https://i.imgur.com/NfL3wEt.png)

<!-- TODO: Figure MULTIPLICATION is wrong! change: subindices and exponents -->

As the set of generators are fixed points of the curve, their multiples can be precomputed and hard-coded in the circuit, Then, it is possible to select the right points by using lookup windows. This is done as shown in the circuit called **SELECTOR**, represented in the figure below. In this case, the design makes use of 3-bit windows, which means that the circuit receives a 3-bit chunk input `m_j = [b0 b1 b2]` and returns the point `enc(m_j)*P_i`. The first two bits of the input are used to select the right multiple of the point and last bit decides the sign of the point. The sign determines if the `x`-coordinate should be taken positive or negative, as with Edwards curves, negating a point corresponds to the negation of its first coordinate. 

![](https://i.imgur.com/uLpB90G.png)

#### Note on efficiency
Each 3-bit message chunk corresponds to a window called selector and each chunk is encoded as an integer from the set `{-4,..,4}\{0}`. This allows a more efficient lookup of the window entry for each chunk than if the set `{1,..,8}` had been used, because a point can be conditionally negated using only a single constraint.

#### Note on security
As there are up to 62 segments per each generator `P_i`, the largest multiple of the generator `P_i` is `nxP_i` with 
```
n = 2^0 * 4 + 2^4 * 4 + ... + (2^4)^61 * 4 
```
It is easy to check that `n < (l-1)/2`, which prevents overflow. 


## Example (or test vectors)

TODO: Add generators of Baby Jubjub + add intermediate results, if possible.

### Test vector 1

The Pedersen hash of 

```
M = 0
```
is the point 
```
H(M) = (3293356515610993045079966956177080131157890267334663226259472478712367818746,20570562226431668734460952502559008517794812804909793924337438584847726792503)
```

### Test vector 2

The Pedersen hash of (253 ones?)

```
M = 
```
is the point 
```
H(M) = (19092467152194012325865035228998940905832420421599727109297982302583412687773,19649890926653253036180932065143651127102491817151864665933125818825159044633)
```
