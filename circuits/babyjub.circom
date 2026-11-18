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
pragma circom 2.1.5;

include "bitify.circom";
include "montgomery.circom";
include "escalarmul/escalarmulfix.circom";
include "comparators.circom";
include "buses.circom";

// The templates and functions of this file only work for finite field F_p = bn128,
// with the prime number p = 21888242871839275222246405745257275088548364400416034343698204186575808495617.

/*
    Baby Jubjub elliptic curve
    ==========================

    Reference: EIP-2494 "Baby Jubjub Elliptic Curve"
               https://eips.ethereum.org/EIPS/eip-2494

    Baby Jubjub is a twisted Edwards curve defined over the scalar field F_r of
    BN254, the field circom works in by default. All curve arithmetic below is
    therefore native field arithmetic and needs no non-native emulation.

        r = 21888242871839275222246405745257275088548364400416034343698204186575808495617

    Twisted Edwards form:

        a*x^2 + y^2 = 1 + d*x^2*y^2,  with a = 168700, d = 168696

    Group structure:

        curve order  n = 8 * l
        cofactor     h = 8
        subgroup     l = 2736030358979909402780800718157159386076813972158567259200215660948447373041
                         (251-bit prime)

    Distinguished points:

        identity   O = (0, 1)
        negation   -(x, y) = (-x, y)
        generator  G = (995203441582195749578291179787384436505546430278305826713579947235728471134,
                        5472060717959818805561601436314318772137091100104008585924551046643952123905)
                   generates the full group of order n.
        base point B = 8*G
                     = (5299619240641551281634865583518297030282874472190772894086521144482721001553,
                        16950150798460657717958625567821834550301663161624707787222815936182638968203)
                   generates the prime-order subgroup of order l.
*/

/*
    spec tag babyedwards: 168700*(p.x)^2 + (p.y)^2 = 1 + 168696*(p.x)^2*(p.y)^2
    spec tag babymontgomery: (p.y)^2 = (p.x)^3 + 168698*(p.x)^2 + p.x
    informal spec insubgroupl: the point only belongs to the subgroup of order l of the curve (and no other subgroup).
    informal spec insubgrouplorunit: the point belongs to the subgroup of order l of the curve, i.e. it has order l or it is the identity (0, 1).
*/

/*
*** BabyAdd(): template that receives two points of the Baby-Jubjub curve in twisted Edwards form and returns the addition of the points.
        - Inputs: p1 = (x1, y1) -> bus representing a point of the curve in twisted Edwards form
                  p2 = (x2, y2) -> bus representing a point of the curve in twisted Edwards form
        - Outputs: pout = (xout, yout) -> bus representing a point of the curve in twisted Edwards form, pout = p1 + p2

    Twisted Edwards Addition Law:
                                               x1*y2 + y1*x2         y1*y2 - a * x1*x2
    [xout, yout] = [x1, y1] + [x2, y2] = [ --------------------- , --------------------- ]
                                            1 + d * x1*x2*y1*y2     1 - d * x1*x2*y1*y2     

    On Baby-Jubjub a is a square and d is not, so by the Bernstein-Lange criterion this law
    is complete: neither denominator can vanish for points on the curve. The template is
    therefore correct for any two points, including equal ones and the identity, and needs
    no precondition from the caller. MontgomeryAdd in montgomery.circom is cheaper but
    incomplete, so it is the right choice only where the caller can guarantee that the two
    points differ in x.

    Inputs must be on the curve.
*/

template BabyAdd() {
    input Point {babyedwards} pin1,pin2;
    output Point {babyedwards} pout;
    
    signal beta;
    signal gamma;
    signal delta;
    signal tau;

    var a = 168700;
    var d = 168696;

    beta <== pin1.x*pin2.y;
    gamma <== pin1.y*pin2.x;
    delta <== (-a*pin1.x + pin1.y)*(pin2.x + pin2.y);
    tau <== beta * gamma;
    
    pout.x <-- (beta + gamma) / (1 + d*tau);
    (1 + d*tau) * pout.x === (beta + gamma);

    pout.y <-- (delta + a*beta - gamma) / (1 - d*tau);
    (1 - d*tau)*pout.y === (delta + a*beta - gamma);
}



/*
*** BabyDouble(): template that receives a point pin of the Baby-Jubjub curve in twisted Edwards form and returns the point 2 * pin.
        - Inputs: pin = (x1, y1) -> bus representing a point of the curve in twisted Edwards form
        - Outputs: pout = (x2, y2) -> bus representing a point of the curve in twisted Edwards form, 2 * pin = pout
         
    Twisted Edwards Doubling Law: 2 * [x, y] = [x, y] + [x, y]
    Via BabyAdd (the addition law is complete).
    
*/

template BabyDbl() {
    input Point {babyedwards} pin;
    output Point {babyedwards} pout;
    component adder = BabyAdd();

    adder.pin1 <== pin;
    adder.pin2 <== pin;
    pout <== adder.pout;
}


/*
*** BabyCheck(): template that receives an input point pin and checks if it belongs to the Baby-Jubjub curve in twisted Edwards form.
        - Inputs: pin = (x1, y1) -> bus representing the point that we want to check
        - Outputs: pout = (x2, y2) -> two field values representing the same point as the input but with the babyedwards tag
                                      attached to point out it is a point of the Baby-Jubjub curve in twisted Edwards form
        
    The set of solutions of BabyCheck()(p) are the points of the Baby-Jubjub curve in twisted Edwards form.
    They must fulfil the equation a*x^2 + y^2 = 1 + d*x^2*y^2, a = 168700, d = 168696.
    
*/


template BabyCheck() {
    input Point pin;
    output Point {babyedwards} pout;

    // Point p2;
    signal x2;
    signal y2;

    var a = 168700;
    var d = 168696;

    x2 <== pin.x*pin.x; //x2 = pin.x^2
    y2 <== pin.y*pin.y; //y2 = pin.y^2
    
    a*x2 + y2 === 1 + d*x2*y2;
    
    pout <== pin; 
}


/*
*** BabyPbk(): template that receives an input in representing a value in the prime subgroup with order
               r = 2736030358979909402780800718157159386076813972158567259200215660948447373041,
               and returns the point of the Baby-Jubjub curve in twisted Edwards form in * P, with P being the point
               P = (5299619240641551281634865583518297030282874472190772894086521144482721001553, 16950150798460657717958625567821834550301663161624707787222815936182638968203)

This template is used to extract the public key from the private key.
        - Inputs: in -> field value in [1,r-1]
        - Outputs: A = (x, y) -> two field values representing a point of the curve in Edwards form, in * P = A
    
*/

template BabyPbk() {
    input signal {minvalue, maxvalue} in;
    output Point {babyedwards} A;


    var r = 2736030358979909402780800718157159386076813972158567259200215660948447373041;
    assert(in.minvalue > 0 && in.maxvalue < r);
    var BASE8[2] = [
        5299619240641551281634865583518297030282874472190772894086521144482721001553,
        16950150798460657717958625567821834550301663161624707787222815936182638968203
    ];

    component pvkBits = Num2Bits(253);
    pvkBits.in <== in;

    component mulFix = EscalarMulFix(253, BASE8);

    mulFix.e <== pvkBits.out;
    A <== mulFix.pout;
}

/*
*** CheckandAddSubgroupLOnly(): template that receives a point of the Baby-Jubjub curve in twisted Edwards
                          form and returns 8 times the point, checking that it is not the identity.
        - Inputs: in -> bus representing a point of the curve in twisted Edwards form
        - Outputs: out8 -> bus representing the point 8*in in twisted Edwards form, with out8.x != 0 (checked)

    Multiplying by the cofactor 8 sends the point to the subgroup of order l, and out8.x != 0
    ensures that 8*in is not the identity, so out8 has order l.
    The multiplication is done with three BabyDbl, which is complete.
*/

template CheckandAddSubgroupLOnly() {
  input Point {base, babyedwards} in;
  output Point {insubgroupl,babyedwards} out8;

  out8.insubgroupl = in.base;
  out8 <== BabyDbl()(BabyDbl()(BabyDbl()(in)));

  signal isz <== IsZero()(out8.x);
  isz === 0;
}

/*
*** CheckandAddSubgroupLOrUnit(): template that receives a point of the Baby-Jubjub curve in twisted Edwards
                          form and returns 8 times the point.
        - Inputs: in -> bus representing a point of the curve in twisted Edwards form
        - Outputs: out8 -> bus representing the point 8*in in twisted Edwards form

    Multiplying by the cofactor 8 sends the point to the subgroup of order l, so out8 has
    order l or it is the identity (0, 1). Nothing else needs to be checked.
    The multiplication is done with three BabyDbl, which is complete.
*/

template CheckandAddSubgroupLOrUnit() {
  input Point {base, babyedwards} in;
  output Point {insubgrouplorunit,babyedwards} out8;

  out8.insubgrouplorunit = in.base;
  out8 <== BabyDbl()(BabyDbl()(BabyDbl()(in)));
}

/*
*** isSubgroupLPoint(x, y): function that returns 1 if (x, y) is one of the constant points used in
                          the library that are known to have order l, and 0 otherwise.

    Each of these points has been checked to be on the curve, to have x != 0 and to satisfy
    l * P = O, so it has order l. A new constant base must be checked and added here.
*/

function isSubgroupLPoint(x, y) {
    //Component x of all these points must be different.
    var POINTS[11][2] = [
        // BASE8 (babyjub.circom, eddsa*.circom)
        [5299619240641551281634865583518297030282874472190772894086521144482721001553,
         16950150798460657717958625567821834550301663161624707787222815936182638968203],
        // Pedersen BASE[0] (pedersen.circom)
        [10457101036533406547632367118273992217979173478358440826365724437999023779287,
         19824078218392094440610104313265183977899662750282163392862422243483260492317],
        // Pedersen BASE[1] (pedersen.circom)
        [2671756056509184035029146175565761955751135805354291559563293617232983272177,
         2663205510731142763556352975002641716101654201788071096152948830924149045094],
        // Pedersen BASE[2] (pedersen.circom)
        [5802099305472655231388284418920769829666717045250560929368476121199858275951,
         5980429700218124965372158798884772646841287887664001482443826541541529227896],
        // Pedersen BASE[3] (pedersen.circom)
        [7107336197374528537877327281242680114152313102022415488494307685842428166594,
         2857869773864086953506483169737724679646433914307247183624878062391496185654],
        // Pedersen BASE[4] (pedersen.circom)
        [20265828622013100949498132415626198973119240347465898028410217039057588424236,
         1160461593266035632937973507065134938065359936056410650153315956301179689506],
        // Pedersen BASE[5] (pedersen.circom)
        [1487999857809287756929114517587739322941449154962237464737694709326309567994,
         14017256862867289575056460215526364897734808720610101650676790868051368668003],
        // Pedersen BASE[6] (pedersen.circom)
        [14618644331049802168996997831720384953259095788558646464435263343433563860015,
         13115243279999696210147231297848654998887864576952244320558158620692603342236],
        // Pedersen BASE[7] (pedersen.circom)
        [6814338563135591367010655964669793483652536871717891893032616415581401894627,
         13660303521961041205824633772157003587453809761793065294055279768121314853695],
        // Pedersen BASE[8] (pedersen.circom)
        [3571615583211663069428808372184817973703476260057504149923239576077102575715,
         11981351099832644138306422070127357074117642951423551606012551622164230222506],
        // Pedersen BASE[9] (pedersen.circom)
        [18597552580465440374022635246985743886550544261632147935254624835147509493269,
         6753322320275422086923032033899357299485124665258735666995435957890214041481]
    ];

    for (var i = 0; i < 11; i++) {
        if (x == POINTS[i][0] && y == POINTS[i][1]) {
            return 1;
        }
    }
    return 0;
}

/*
*** SubgroupLOnlyCheckFix(Base, n): template that receives n constant points Base[i] = [x, y] of the Baby-Jubjub curve
                          in twisted Edwards form and returns them as buses.
        - Outputs: out[i] -> bus representing the point Base[i] in twisted Edwards form

    Each Base[i] is checked at compile time to be one of the points of isSubgroupLPoint, which
    have order l. No constraints are generated.
*/

template SubgroupLOnlyCheckFix(Base) {
  output Point {insubgroupl,babyedwards} out;

    out.insubgroupl = Base[0];
    assert(isSubgroupLPoint(Base[0], Base[1]) == 1);
    out.x <== Base[0];
    out.y <== Base[1];
}
