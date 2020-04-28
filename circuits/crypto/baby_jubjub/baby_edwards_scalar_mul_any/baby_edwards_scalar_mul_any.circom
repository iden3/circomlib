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

include "_segment_mul_any.circom";
include "../baby_edwards_add/baby_edwards_add.circom";
include "../baby_montgomery2edwards/baby_montgomery2edwards.circom";
include "../baby_montgomery_dbl/baby_montgomery_dbl.circom";
include "../../../basics/comparators/is_zero/is_zero.circom";

// This function assumes that p is in the subgroup and it is different to 0.

template BabyEdwardsScalarMulAny(n) {
    signal input e[n];              // Input in binary format
    signal input p[2];              // Point (Twisted format)
    signal output out[2];           // Point (Twisted format)

    var nsegments = (n-1)\148 +1;
    var nlastsegment = n - (nsegments-1)*148;

    component segments[nsegments];
    component doublers[nsegments-1];
    component m2e[nsegments-1];
    component adders[nsegments-1];
    component zeropoint = IsZero();
    zeropoint.in <== p[0];

    var s;
    var i;
    var nseg;

    for (s=0; s<nsegments; s++) {

        nseg = (s < nsegments-1) ? 148 : nlastsegment;

        segments[s] = SegmentMulAny(nseg);

        for (i=0; i<nseg; i++) {
            e[s*148+i] ==> segments[s].e[i];
        }

        if (s==0) {
            // force G8 point if input point is zero
            segments[s].p[0] <== p[0] + (5299619240641551281634865583518297030282874472190772894086521144482721001553 - p[0])*zeropoint.out;
            segments[s].p[1] <== p[1] + (16950150798460657717958625567821834550301663161624707787222815936182638968203 - p[1])*zeropoint.out;
        } else {
            doublers[s-1] = BabyMontgomeryDbl();
            m2e[s-1] = BabyMontgomery2Edwards();
            adders[s-1] = BabyEdwardsAdd();

            segments[s-1].dbl[0] ==> doublers[s-1].in[0];
            segments[s-1].dbl[1] ==> doublers[s-1].in[1];

            doublers[s-1].out[0] ==> m2e[s-1].in[0];
            doublers[s-1].out[1] ==> m2e[s-1].in[1];

            m2e[s-1].out[0] ==> segments[s].p[0];
            m2e[s-1].out[1] ==> segments[s].p[1];

            if (s==1) {
                segments[s-1].out[0] ==> adders[s-1].x1;
                segments[s-1].out[1] ==> adders[s-1].y1;
            } else {
                adders[s-2].xout ==> adders[s-1].x1;
                adders[s-2].yout ==> adders[s-1].y1;
            }
            segments[s].out[0] ==> adders[s-1].x2;
            segments[s].out[1] ==> adders[s-1].y2;
        }
    }

    if (nsegments == 1) {
        segments[0].out[0]*(1-zeropoint.out) ==> out[0];
        segments[0].out[1]+(1-segments[0].out[1])*zeropoint.out ==> out[1];
    } else {
        adders[nsegments-2].xout*(1-zeropoint.out) ==> out[0];
        adders[nsegments-2].yout+(1-adders[nsegments-2].yout)*zeropoint.out ==> out[1];
    }
}