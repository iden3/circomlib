# `elliptic_curves`

This folder contains the templates to do operations on different elliptic curves.

## Structure of the Folder

- [`baby_jubjub`](doc/elliptic_curves/baby_jubjub)
    - [`edwards`](doc/elliptic_curves/baby_jubjub/edwards)
        - [`babyadd`](doc/elliptic_curves/baby_jubjub/edwards/babyadd)
        - [`babycheck`](doc/elliptic_curves/baby_jubjub/edwards/babycheck)
        - [`babydbl`](doc/elliptic_curves/baby_jubjub/edwards/babydbl)
        - [`babypbk`](doc/elliptic_curves/baby_jubjub/edwards/babypbk)
        - [`scalar_mul`](doc/elliptic_curves/baby_jubjub/edwards/scalar_mul)
            - [`scalarmul`](doc/elliptic_curves/baby_jubjub/edwards/scalar_mul/scalarmul)
            - [`scalarmulany`](doc/elliptic_curves/baby_jubjub/edwards/scalar_mul/scalarmulany)
            - [`scalarmulfix`](doc/elliptic_curves/baby_jubjub/edwards/scalar_mul/scalarmulfix)
            - [`scalarmulwtable`](doc/elliptic_curves/baby_jubjub/edwards/scalar_mul/scalarmulwtable)
    - [`edwards2montgomery`](doc/elliptic_curves/baby_jubjub/edwards2montgomery)
    - [`montgomery`](doc/elliptic_curves/baby_jubjub/montgomery)
        - [`montgomeryadd`](doc/elliptic_curves/baby_jubjub/montgomery/montgomeryadd)
        - [`montgomerydouble`](doc/elliptic_curves/baby_jubjub/montgomery/montgomerydouble)
    - [`montgomery2edwards`](doc/elliptic_curves/baby_jubjub/montgomery2edwards)
    - [`point2bits`](doc/elliptic_curves/baby_jubjub/point2bits)

## Background on Elliptic Curves