/*
    Copyright 2018 0KIMS association.

    This file is part of circom (Zero Knowledge Circuit Compiler).

    circom is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    circom is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with circom. If not, see <https://www.gnu.org/licenses/>.
*/
pragma circom 2.0.0;

include "montgomery.circom";
include "mux3.circom";
include "babyjub.circom";

/*
    Pedersen hash over Baby Jubjub (windowed, Zcash Sapling style).

    The n input bits are split into segments of 200 bits. Each segment is split
    into 50 windows of 4 bits [b0, b1, b2, b3], and each window is encoded as a
    signed digit:

        enc = (1 + b0 + 2*b1 + 4*b2) * (1 - 2*b3)    in {-8..-1, 1..8}

        out = sum_s ( sum_j enc_{s,j} * 32^j ) * BASE[s]

    Windows are spaced by 32 = 2^5 > 2*8, so the encoding is injective. Missing
    bits in the last window are padded with 0.

    BASE[s] = 8 * (a point derived from blake256("PedersenGenerator_<s>_<try>")),
    so it lies in the prime-order subgroup. Only 10 bases exist, so n <= 2000.

    Collision resistance holds only for a fixed n. Zero padding means, for
    example, that Pedersen(3)([1,0,1]) == Pedersen(4)([1,0,1,0]).
*/

/*
    One 4-bit window, in Montgomery form:
        out  = enc(in) * base
        out8 = 8 * base
    The table (1..8)*base is built with one double and six adds, MultiMux3
    selects it with in[0..2], and in[3] negates the result, since -(u, v) = (u, -v).
*/
template Window4() {
    signal input in[4];
    signal input base[2];
    signal output out[2];
    signal output out8[2];

    component mux = MultiMux3(2);
    mux.s[0] <== in[0];
    mux.s[1] <== in[1];
    mux.s[2] <== in[2];

    // mux.c[*][k] = (k + 1)*base
    component dbl2 = MontgomeryDouble();
    component adders[6];

    mux.c[0][0] <== base[0];
    mux.c[1][0] <== base[1];

    dbl2.in[0] <== base[0];
    dbl2.in[1] <== base[1];
    mux.c[0][1] <== dbl2.out[0];
    mux.c[1][1] <== dbl2.out[1];

    for (var k = 2; k < 8; k++) {
        adders[k - 2] = MontgomeryAdd();
        adders[k - 2].in1[0] <== base[0];
        adders[k - 2].in1[1] <== base[1];
        if (k == 2) {
            adders[k - 2].in2[0] <== dbl2.out[0];
            adders[k - 2].in2[1] <== dbl2.out[1];
        } else {
            adders[k - 2].in2[0] <== adders[k - 3].out[0];
            adders[k - 2].in2[1] <== adders[k - 3].out[1];
        }
        mux.c[0][k] <== adders[k - 2].out[0];
        mux.c[1][k] <== adders[k - 2].out[1];
    }

    out8[0] <== adders[5].out[0];
    out8[1] <== adders[5].out[1];

    out[0] <== mux.out[0];
    out[1] <== -mux.out[1]*2*in[3] + mux.out[1];   // negate v if in[3] = 1
}

/*
    One segment: out = (sum_j enc_j * 32^j) * base, with base and out in Edwards form.
    Window j uses 32^j * base, computed as two doublings of the previous out8.
    The Montgomery accumulator never meets an exceptional case: with at most 50
    windows, |sum_{k<j} enc_k * 32^k| < 32^j <= |enc_j * 32^j|, and every partial
    sum is below 2^249 < l.
*/
template Segment(nWindows) {
    signal input in[nWindows*4];
    signal input base[2];
    signal output out[2];

    component e2m = Edwards2Montgomery();
    e2m.in[0] <== base[0];
    e2m.in[1] <== base[1];

    component windows[nWindows];
    component doublers1[nWindows - 1];
    component doublers2[nWindows - 1];
    component adders[nWindows - 1];

    for (var i = 0; i < nWindows; i++) {
        windows[i] = Window4();
        for (var j = 0; j < 4; j++) {
            windows[i].in[j] <== in[4*i + j];
        }

        if (i == 0) {
            windows[i].base[0] <== e2m.out[0];
            windows[i].base[1] <== e2m.out[1];
        } else {
            doublers1[i - 1] = MontgomeryDouble();
            doublers2[i - 1] = MontgomeryDouble();
            doublers1[i - 1].in[0] <== windows[i - 1].out8[0];
            doublers1[i - 1].in[1] <== windows[i - 1].out8[1];
            doublers2[i - 1].in[0] <== doublers1[i - 1].out[0];
            doublers2[i - 1].in[1] <== doublers1[i - 1].out[1];

            windows[i].base[0] <== doublers2[i - 1].out[0];
            windows[i].base[1] <== doublers2[i - 1].out[1];

            adders[i - 1] = MontgomeryAdd();
            if (i == 1) {
                adders[i - 1].in1[0] <== windows[0].out[0];
                adders[i - 1].in1[1] <== windows[0].out[1];
            } else {
                adders[i - 1].in1[0] <== adders[i - 2].out[0];
                adders[i - 1].in1[1] <== adders[i - 2].out[1];
            }
            adders[i - 1].in2[0] <== windows[i].out[0];
            adders[i - 1].in2[1] <== windows[i].out[1];
        }
    }

    component m2e = Montgomery2Edwards();
    if (nWindows > 1) {
        m2e.in[0] <== adders[nWindows - 2].out[0];
        m2e.in[1] <== adders[nWindows - 2].out[1];
    } else {
        m2e.in[0] <== windows[0].out[0];
        m2e.in[1] <== windows[0].out[1];
    }

    out[0] <== m2e.out[0];
    out[1] <== m2e.out[1];
}

/*
    out = Pedersen hash of the n bits in[0..n-1] (in[0] first), as an Edwards
    point. Segment results are summed with BabyAdd, which is complete.
*/
template Pedersen(n) {
    signal input in[n];
    signal output out[2];

    var BASE[10][2] = [
        [10457101036533406547632367118273992217979173478358440826365724437999023779287, 19824078218392094440610104313265183977899662750282163392862422243483260492317],
        [2671756056509184035029146175565761955751135805354291559563293617232983272177, 2663205510731142763556352975002641716101654201788071096152948830924149045094],
        [5802099305472655231388284418920769829666717045250560929368476121199858275951, 5980429700218124965372158798884772646841287887664001482443826541541529227896],
        [7107336197374528537877327281242680114152313102022415488494307685842428166594, 2857869773864086953506483169737724679646433914307247183624878062391496185654],
        [20265828622013100949498132415626198973119240347465898028410217039057588424236, 1160461593266035632937973507065134938065359936056410650153315956301179689506],
        [1487999857809287756929114517587739322941449154962237464737694709326309567994, 14017256862867289575056460215526364897734808720610101650676790868051368668003],
        [14618644331049802168996997831720384953259095788558646464435263343433563860015, 13115243279999696210147231297848654998887864576952244320558158620692603342236],
        [6814338563135591367010655964669793483652536871717891893032616415581401894627, 13660303521961041205824633772157003587453809761793065294055279768121314853695],
        [3571615583211663069428808372184817973703476260057504149923239576077102575715, 11981351099832644138306422070127357074117642951423551606012551622164230222506],
        [18597552580465440374022635246985743886550544261632147935254624835147509493269, 6753322320275422086923032033899357299485124665258735666995435957890214041481]
    ];

    var nSegments = ((n - 1) \ 200) + 1;
    assert(nSegments <= 10);   // only 10 bases are defined

    component segments[nSegments];

    for (var i = 0; i < nSegments; i++) {
        var nBits = (i == nSegments - 1) ? n - (nSegments - 1)*200 : 200;
        var nWindows = ((nBits - 1) \ 4) + 1;

        segments[i] = Segment(nWindows);
        segments[i].base[0] <== BASE[i][0];
        segments[i].base[1] <== BASE[i][1];

        for (var j = 0; j < nBits; j++) {
            segments[i].in[j] <== in[i*200 + j];
        }
        for (var j = nBits; j < nWindows*4; j++) {
            segments[i].in[j] <== 0;   // padding
        }
    }

    component adders[nSegments - 1];

    for (var i = 0; i < nSegments - 1; i++) {
        adders[i] = BabyAdd();
        if (i == 0) {
            adders[i].x1 <== segments[0].out[0];
            adders[i].y1 <== segments[0].out[1];
        } else {
            adders[i].x1 <== adders[i - 1].xout;
            adders[i].y1 <== adders[i - 1].yout;
        }
        adders[i].x2 <== segments[i + 1].out[0];
        adders[i].y2 <== segments[i + 1].out[1];
    }

    if (nSegments > 1) {
        out[0] <== adders[nSegments - 2].xout;
        out[1] <== adders[nSegments - 2].yout;
    } else {
        out[0] <== segments[0].out[0];
        out[1] <== segments[0].out[1];
    }
}
