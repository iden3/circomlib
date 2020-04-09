# `elliptic_curves`

This folder contains the templates to do operations on different elliptic curves.

## Structure of the Folder

- [`baby_jubjub`](baby_jubjub)
    - [`edwards`](baby_jubjub/edwards)
        - [`babyadd`](baby_jubjub/edwards/babyadd)
        - [`babycheck`](baby_jubjub/edwards/babycheck)
        - [`babydbl`](baby_jubjub/edwards/babydbl)
        - [`babypbk`](baby_jubjub/edwards/babypbk)
        - [`scalar_mul`](baby_jubjub/edwards/scalar_mul)
            - [`scalarmul`](baby_jubjub/edwards/scalar_mul/scalarmul)
            - [`scalarmulany`](baby_jubjub/edwards/scalar_mul/scalarmulany)
            - [`scalarmulfix`](baby_jubjub/edwards/scalar_mul/scalarmulfix)
            - [`scalarmulwtable`](baby_jubjub/edwards/scalar_mul/scalarmulwtable)
    - [`edwards2montgomery`](baby_jubjub/edwards2montgomery)
    - [`montgomery`](baby_jubjub/montgomery)
        - [`montgomeryadd`](baby_jubjub/montgomery/montgomeryadd)
        - [`montgomerydouble`](baby_jubjub/montgomery/montgomerydouble)
    - [`montgomery2edwards`](baby_jubjub/montgomery2edwards)
    - [`point2bits`](baby_jubjub/point2bits)