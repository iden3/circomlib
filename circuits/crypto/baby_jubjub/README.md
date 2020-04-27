# `baby_jubjub`

This folder contains the templates to do operations on [Baby Jubjub](https://github.com/ethereum/EIPs/pull/2494) elliptic curve.

TODO: Add description of the curve

## Structure of the folder

- [`baby_edwards2montgomery`](baby_edwards2montgomery)
- [`baby_edwards_add`](baby_edwards_add)
- [`baby_edwards_bits2point`](baby_edwards_bits2point)
- [`baby_edwards_bits2point_strict`](baby_edwards_bits2point_strict)
- [`baby_edwards_check`](baby_edwards_check)
- [`baby_edwards_dbl`](baby_edwards_dbl)
- [`baby_edwards_pbk`](baby_edwards_pbk)
- [`baby_edwards_point2bits`](baby_edwards_point2bits)
- [`baby_edwards_point2bits_strict`](baby_edwards_point2bits_strict)
- [`baby_edwards_scalar_mul`](baby_edwards_scalar_mul)
    - [`baby_edwards_scalar_mul_w4_table`](baby_edwards_scalar_mul/baby_edwards_scalar_mul_w4_table)
    - [`baby_edwards_scalar_mul_window`](baby_edwards_scalar_mul/baby_edwards_scalar_mul_window)
- [`baby_edwards_scalar_mul_any`](baby_edwards_scalar_mul_any)
    - [`bit_element_mul_any`](baby_edwards_scalar_mul_any/bit_element_mul_any)
    - [`multiplexor2`](baby_edwards_scalar_mul_any/multiplexor2)
    - [`segment_mul_any`](baby_edwards_scalar_mul_any/segment_mul_any)
- [`baby_edwards_scalar_mul_fix`](baby_edwards_scalar_mul_fix)
    - [`segment_mul_fix`](baby_edwards_scalar_mul_fix/segment_mul_fix)
    - [`window_mul_fix`](baby_edwards_scalar_mul_fix/window_mul_fix)
- [`baby_montgomery2edwards`](baby_montgomery2edwards)
- [`baby_montgomery_add`](baby_montgomery_add)
- [`baby_montgomery_dbl`](baby_montgomery_dbl)