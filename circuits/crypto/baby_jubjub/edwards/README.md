# `baby_jubjub`

This folder contains the templates to do operations on [Baby Jubjub elliptic curve](https://github.com/barryWhiteHat/baby_jubjub) in twisted Edwards form.

See: https://github.com/iden3/research/blob/master/documentation/Arithmetic.md

## Structure of the Folder

- [`edwards`](edwards)
    - [`babyadd`](edwards/babyadd)
    - [`babycheck`](edwards/babycheck)
    - [`babydbl`](edwards/babydbl)
    - [`babypbk`](edwards/babypbk)
    - [`scalar_mul`](edwards/scalar_mul)
        - [`scalarmul`](edwards/scalar_mul/scalarmul)
        - [`scalarmulany`](edwards/scalar_mul/scalarmulany)
        - [`scalarmulfix`](edwards/scalar_mul/scalarmulfix)
        - [`scalarmulwtable`](edwards/scalar_mul/scalarmulwtable)
- [`edwards2montgomery`](edwards2montgomery)
- [`montgomery`](montgomery)
    - [`montgomeryadd`](montgomery/montgomeryadd)
    - [`montgomerydouble`](montgomery/montgomerydouble)
- [`montgomery2edwards`](montgomery2edwards)
- [`point2bits`](point2bits)