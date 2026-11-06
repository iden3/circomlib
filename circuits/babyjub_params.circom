pragma circom 2.0.0;

/*
    Baby Jubjub curve parameters.

        a*x^2 + y^2 = 1 + d*x^2*y^2
*/
function babyjub_a() { return 168700; }
function babyjub_d() { return 168696; }

// Generator G of the full group (order 8*l).
function babyjub_generator() {
    var g[2] = [
        995203441582195749578291179787384436505546430278305826713579947235728471134,
        5472060717959818805561601436314318772137091100104008585924551046643952123905
    ];
    return g;
}

// Base point B = 8*G, generator of the prime-order subgroup (order l).
function babyjub_base8() {
    var b[2] = [
        5299619240641551281634865583518297030282874472190772894086521144482721001553,
        16950150798460657717958625567821834550301663161624707787222815936182638968203
    ];
    return b;
}
