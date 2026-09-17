# CircomLib/Circuits

Circuit templates for standard operations and cryptographic primitives, written in
[circom](https://github.com/iden3/circom).

Requires **circom 2.2.0 or later**: buses were introduced in circom 2.2.0 (tags in
2.1.x). The `pragma` lines in the files state lower versions; they are minimums the
compiler checks against itself and do not enforce this requirement.

## Where the specifications live

Each template is specified in a comment directly above it, in the form

```
/*
*** TemplateName(params): what the template does
        - Inputs:  in  -> what it is, and which tags it requires
        - Outputs: out -> what it is, and which tags it satisfies

    Example: ...
*/
```

That comment is the reference for the template: what it computes, what it assumes
about its inputs, and what it guarantees about its outputs. This file only indexes
what exists and where.

## Tags

A tag records a property of a signal. The compiler propagates tags but does not
check them, so a tag is an assumption at the point where it is required and an
obligation at the point where it is granted. To attach one to a signal that does
not carry it yet, pass the signal through the matching template in
`tags-managing.circom`, which adds the constraints that make the property hold.

| Tag              | Meaning                                                    |
| ---------------- | ---------------------------------------------------------- |
| `binary`         | `0 <= in <= 1`                                             |
| `maxbit`         | `0 <= in <= 2**in.maxbit - 1`                              |
| `maxvalue`       | `0 <= in <= in.maxvalue`                                   |
| `minvalue`       | `in >= in.minvalue`                                        |
| `max_abs`        | `-in.max_abs <= in <= in.max_abs`                          |
| `unique`         | the bits of a `BinaryNumber` represent a value below `p`   |
| `babyedwards`    | `168700*x^2 + y^2 = 1 + 168696*x^2*y^2`                    |
| `babymontgomery` | `y^2 = x^3 + 168698*x^2 + x`                               |

Tags on the inputs of the `main` component are assumed, never checked. A circuit
whose `main` takes untrusted input must therefore add the checks itself, as the
wrappers under `test/circuits` do.

## Buses

`buses.circom` groups signals that travel together:

| Bus               | Fields                                |
| ----------------- | ------------------------------------- |
| `Point()`         | `x`, `y`                              |
| `BinaryPoint(n)`  | `binY[n]`, `signX`, both `binary`     |
| `BinaryNumber(n)` | `bits[n]`, `binary`                   |

`smt/smtbuses.circom` adds `SMTVerifierState()` and `SMTProcessorState()` for the
state machines of the sparse Merkle tree circuits.

## Field

Some files are written for the BN254 scalar field and some work over any prime.
Each file says which at the top; the summary is:

- **Any prime field**: `aliascheck`, `binsub`, `binsum`, `bitify`, `comparators`,
  `gates`, `tags-managing`.
- **BN254 only**: `babyjub`, `eddsapedersen`, `eddsapedersen_old`, `eddsaposeidon`,
  `montgomery`, `pedersen`, `pedersen_old`, `pointbits`, and everything under
  `escalarmul/`.

The remaining files do not state a requirement.

## Index

### Numbers and bits

| File            | Provides                                                                                     |
| --------------- | -------------------------------------------------------------------------------------------- |
| `bitify`        | `Num2Bits(n)`, `Num2Bits_strict()`, `Bits2Num(n)`, `Bits2Num_strict()`, `Num2BitsNeg(n)`, and the functions `maxbits()`, `nbits(a)` |
| `binnum`        | `Num2Bin(n)`, `Bin2Num(n)`, `Num2BinNeg(n)` — the same conversions over the `BinaryNumber` bus |
| `aliascheck`    | `AliasCheck()` — the bits represent a value below `p`                                          |
| `binsum`        | `BinSum(n, ops)`                                                                               |
| `binsub`        | `BinSub(n)`                                                                                    |

### Comparison and logic

| File            | Provides                                                                                     |
| --------------- | -------------------------------------------------------------------------------------------- |
| `comparators`   | `IsZero()`, `IsEqual()`, `ForceEqualIfEnabled()`, `LessThan(n)`, `LessEqThan(n)`, `GreaterThan(n)`, `GreaterEqThan(n)`, `Sign()`, `CompConstant(n, ct)` |
| `gates`         | `XOR()`, `AND()`, `OR()`, `NOT()`, `NAND()`, `NOR()`, `MultiAND(n)`                            |
| `switcher`      | `Switcher()`                                                                                   |
| `mux1`          | `Mux1()`, `MultiMux1(n)`                                                                       |
| `mux2`          | `Mux2()`, `MultiMux2(n)`                                                                       |
| `mux3`          | `Mux3()`, `MultiMux3(n)`                                                                       |
| `mux4`          | `Mux4()`, `MultiMux4(n)`                                                                       |

### Tags

| File             | Provides                                                                                    |
| ---------------- | ------------------------------------------------------------------------------------------- |
| `tags-managing`  | `BinaryCheck()`, `BinaryCheckArray(n)`, `MaxbitCheck(n)`, `MaxbitCheckArray(n, m)`, `MaxValueCheck(ct)`, `MinValueCheck(ct)`, `MinMaxValueCheck(ct1, ct2)`, `MaxAbsValueTagCheck(n)` |

### Baby Jubjub

[Baby Jubjub](https://github.com/barryWhiteHat/baby_jubjub) is the twisted Edwards
curve `168700*x^2 + y^2 = 1 + 168696*x^2*y^2` over the BN254 scalar field.

| File                          | Provides                                                                     |
| ----------------------------- | ----------------------------------------------------------------------------- |
| `babyjub`                     | `BabyAdd()`, `BabyDbl()`, `BabyCheck()`, `BabyPbk()`                           |
| `montgomery`                  | `Edwards2Montgomery()`, `Montgomery2Edwards()`, `MontgomeryAdd()`, `MontgomeryDouble()`, `MontgomeryBabyCheck()` |
| `pointbits`                   | `Bits2Point_Strict()`, `Point2Bits_Strict()`, and the function `sqrt(n)`       |
| `escalarmul/escalarmul`       | `EscalarMul(n, base)`, `EscalarMulWindow(base, k)`                             |
| `escalarmul/escalarmulany`    | `EscalarMulAny(n)` and its parts `SegmentMulAny(n)`, `BitElementMulAny()`, `MultiplexorEdwards2()`, `MultiplexorMontgomery2()` |
| `escalarmul/escalarmulfix`    | `EscalarMulFix(n, BASE)` and its parts `SegmentMulFix(nWindows)`, `WindowMulFix()` |
| `escalarmul/escalarmulw4table`| the functions `EscalarMulW4Table(base, k)`, `pointAdd(x1, y1, x2, y2)`         |

`EscalarMulAny` assumes its point is in the prime order subgroup and is not the
identity. No tag expresses that, so the caller is responsible for it.

### Hashes

| File                   | Provides                                                                            |
| ---------------------- | ------------------------------------------------------------------------------------ |
| `poseidon`             | `Poseidon(nInputs)`, `PoseidonEx(nInputs, nOuts)`, constants in `poseidon_constants`  |
| `poseidon_old`         | `Poseidon(nInputs)`, the unoptimized formulation, constants in `poseidon_constants_old` |
| `pedersen`             | `Pedersen(n)`, built from `Segment(nWindows)` and `Window4()`                          |
| `pedersen_old`         | `Pedersen(n)`, the previous formulation                                                |
| `sha256/sha256`        | `Sha256(nBits)`, with `Sha256compression()` and the round templates beside it          |
| `sha256/sha256_2`      | `Sha256_2()` — two field elements to one                                               |

`poseidon` and `poseidon_old` define the same template name, as do `pedersen` and
`pedersen_old`, so a circuit includes one or the other, never both.

The round functions these are built from are not meant to be instantiated directly:
`Sigma()`, `Ark(t, C, r)`, `Mix(t, M)`, `MixLast(t, M, s)` and `MixS(t, S, r)` for
Poseidon; `Window4()` and `Segment(nWindows)` for Pedersen; and, under `sha256/`,
`Ch_t(n)`, `Maj_t(n)`, `Xor3(n)`, `RotR(n, r)`, `ShR(n, r)`, `SmallSigma(ra, rb, rc)`,
`BigSigma(ra, rb, rc)`, `SigmaPlus()`, `T1()`, `T2()` and the constant tables
`H(x)`, `K(x)`. `sha256/main.circom` is a worked example with its own `main`
component rather than a template to include.

### Signatures

| File                 | Provides                                                                    |
| -------------------- | ---------------------------------------------------------------------------- |
| `eddsapedersen`      | `EdDSAPedersenVerifier(n)` — EdDSA over Baby Jubjub with the Pedersen hash    |
| `eddsapedersen_old`  | `EdDSAPedersenVerifier(n)`, the previous formulation                          |
| `eddsaposeidon`      | `EdDSAPoseidonVerifier()` — the same protocol with the Poseidon hash          |

### Sparse Merkle tree

An implementation of [sparse Merkle trees](https://ethresear.ch/t/optimizing-sparse-merkle-trees/3751).

| File                    | Provides                                    |
| ----------------------- | ------------------------------------------- |
| `smt/smtverifier`       | `SMTVerifier(nLevels)` — inclusion and exclusion proofs |
| `smt/smtprocessor`      | `SMTProcessor(nLevels)` — insert, update, delete         |
| `smt/smtverifierlevel`  | `SMTVerifierLevel()`                        |
| `smt/smtverifiersm`     | `SMTVerifierSM()`                           |
| `smt/smtprocessorlevel` | `SMTProcessorLevel()`                       |
| `smt/smtprocessorsm`    | `SMTProcessorSM()`                          |
| `smt/smtlevins`         | `SMTLevIns(nLevels)`                        |
| `smt/smthash_poseidon`  | `SMTHash1()`, `SMTHash2()`                  |
| `smt/smtbuses`          | `SMTVerifierState()`, `SMTProcessorState()` |
