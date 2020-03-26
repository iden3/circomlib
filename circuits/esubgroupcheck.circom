include "babyjub.circom";
include "pointbits.circom";

function inSubgroup(P) {
    if (inCurve(P) == 0) return 0;
    var subOrder = 2736030358979909402780800718157159386076813972158567259200215660948447373041;
    var res = mulPointEscalar(P, subOrder);
    if ((res[0]==0)&&(res[1]==1)) {
        return 1;
    } else {
        return 0;
    }
}


template SubgroupDecompress() {
    signal input x;
    signal output y;
    
    var X;
    compute {
        X = x;
    }
    var P = [0, 1]; 
    var A = 168700;
    var D = 168696;

    var t = (A*X*X - 1)/(D*X*X-1);
    var Y = sqrt(t)

    var P1[2];
    var P2[2];

    compute {
        P1 = [X, Y];
        P2 = [X, -Y];
    }
   
    if(inSubgroup(P1)) {
        P = mulPointEscalar(P1, 2394026564107420727433200628387514462817212225638746351800188703329891451411);
    } else if(inCurve(P2)){
        P = mulPointEscalar(P2, 2394026564107420727433200628387514462817212225638746351800188703329891451411);
    }

    component p = InCurve();
    p.in[0] <-- P[0];
    p.in[1] <-- P[1];


    p.out === 1;

    component p8 = BabyMul8();
    p8.x <== p.in[0];
    p8.y <== p.in[1];

    x === p8.xout;
    y <== p8.yout;
}


template InSubgroupCheck() {
    signal input in[2];

    var P0[2];
    compute {
        P0 = [in[0], in[1]];
    }

    var P[2];

    P = mulPointEscalar(P0, 2394026564107420727433200628387514462817212225638746351800188703329891451411);

    component p = InCurve();
    p.in[0] <-- P[0];
    p.in[1] <-- P[1];
    p.out === 1;

    component p8 = BabyMul8();
    p8.x <== p.in[0];
    p8.y <== p.in[1];

    in[0] === p8.xout;
    in[1] <== p8.yout;
}


template IsInSubgroup() {
    signal input in[2];
    signal output out;

    var P0[2];
    compute {
        P0 = [in[0], in[1]];
    }

    var P[2];
    P = mulPointEscalar(P0, 2394026564107420727433200628387514462817212225638746351800188703329891451411);


    //Check big subgroup projection
    component p = InCurve();
    p.in[0] <-- P[0];
    p.in[1] <-- P[1];
    p.out === 1;

    component p8 = BabyMul8();
    p8.x <== p.in[0];
    p8.y <== p.in[1];

    //Compute small subgroup projection
    component r = BabyAdd();
    r.x1 <== in[0];
    r.y1 <== in[1];
    r.x2 <== -p8.xout;
    r.y2 <== p8.yout;

    //ensure, that r is in small subgroup
    component r8 = BabyMul8();
    r8.x <== r.xout;
    r8.y <== r.yout;

    r8.xout === 0;
    r8.yout === 1;

    component z = BabyIsZero();
    z.x <== r.xout;
    z.y <== r.yout;
    out <== z.out;
}