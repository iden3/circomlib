const bigInt = require("big-integer");
const ZqField = require("fflib").ZqField; 
const utils = require("./utils.js");

exports.addPoint = addPoint;
exports.mulPointEscalar = mulPointEscalar;
exports.inCurve = inCurve;
exports.inSubgroup = inSubgroup;
exports.packPoint = packPoint;
exports.unpackPoint = unpackPoint;
exports.Generator = [
    bigInt("995203441582195749578291179787384436505546430278305826713579947235728471134"),
    bigInt("5472060717959818805561601436314318772137091100104008585924551046643952123905")
];
exports.Base8 = [
    bigInt("5299619240641551281634865583518297030282874472190772894086521144482721001553"),
    bigInt("16950150798460657717958625567821834550301663161624707787222815936182638968203")
];
exports.order = bigInt("21888242871839275222246405745257275088614511777268538073601725287587578984328");
exports.subOrder = exports.order.shiftRight(3);
exports.p = bigInt("21888242871839275222246405745257275088548364400416034343698204186575808495617");
exports.A = bigInt("168700");
exports.D = bigInt("168696");
exports.subgroupDecompress = subgroupDecompress;
exports.SWUSelect = SWUSelect;


function subgroupDecompress(x) {
    x = bigInt(x);
    const p = exports.p;
    const x2 = x.mul(x, p);
    const t = exports.A.mul(x2).sub(bigInt.one).mul(exports.D.mul(x2).sub(bigInt.one).inverse(p)).affine(p);
    const y = bn128.Fr.sqrt(t);

    if(inSubgroup([x,y]))
        return [x,y];
    
    if(inSubgroup([x,-y]))
        return [x,-y];
    
    throw("Not a compressed point at subgroup");
}


function WeierstrassCoefficients() {    
    const p = exports.p;
    const s = exports.A.sub(exports.D).mul(bigInt("4").invmod(p)).mod(p);
    const t = exports.A.add(exports.D).mul(bigInt("6").invmod(p)).mod(p);
    
    return [
        s.mul(s).sub(t.mul(t).mul(bigInt("3"))).mod(p),
        t.mul(t).mul(t).mul(bigInt("2")).sub(t.mul(s).mul(s)).mod(p)
    ]

}

function WeierstrassExpr(x) {
    const p = exports.p;
    const [WA, WB] = WeierstrassCoefficients();
    const x3 = x.mul(x).mul(x);
    return x3.add(x.mul(WA)).add(WB).mod(p);
}

function Weierstrass2Edwards(w) {
    const p = exports.p;
    const s = exports.A.sub(exports.D).mul(bigInt("4").invmod(p)).mod(p);
    const t = exports.A.add(exports.D).mul(bigInt("6").invmod(p)).mod(p);
    return [
        w[0].sub(t).mul(w[1].invmod(p)).mod(p),
        w[0].sub(t).sub(s).mul(w[0].sub(t).add(s).invmod(p)).mod(p)
     ]
}





//The Shallue-Woestijne-Ulas Algorithm for point selection on the curve

function SWUSelect(t) {
    const p = exports.p;
    t = bigInt(t);
    // 70297686841582442057940100194421294204074774541372193073554880658839844120511n == sha256("t regularization")
    t = t.isZero(p) ? bigInt("70297686841582442057940100194421294204074774541372193073554880658839844120511") : t;
    const [WA, WB] = WeierstrassCoefficients();
    
    const g = WeierstrassExpr(bigInt.one);
    const t2g = t.mul(t).mul(g).mod(p);
    const t4g2 =  t2g.mul(t2g).mod(p);

    
    const x2 = WB.neg(p).mul(WA.invmod(p)).mul(bigInt.one.add(t4g2.add(t2g).invmod(p))).mod(p);
    const x3 = t2g.mul(x2).mod(p);

    const x = isSquare(WeierstrassExpr(x2)) ? x2 : x3;
    const y = bn128.Fr.sqrt(WeierstrassExpr(x));
    let P = Weierstrass2Edwards([x,y]);
    if (P[0] <= bigInt("10944121435919637611123202872628637544274182200208017171849102093287904247808")) P[0]=P[0].neg(p);
    return mulPointEscalar(P, bigInt(8));
} 



function addPoint(a,b) {
    const F = new ZqField(exports.p);

    const res = [];

    /* does the equivalent of:
     res[0] = bigInt((a[0]*b[1] + b[0]*a[1]) *  bigInt(bigInt("1") + d*a[0]*b[0]*a[1]*b[1]).inverse(q)).affine(q);
    res[1] = bigInt((a[1]*b[1] - cta*a[0]*b[0]) * bigInt(bigInt("1") - d*a[0]*b[0]*a[1]*b[1]).inverse(q)).affine(q);
    */

    const beta = F.mul(a[0],b[1]);
    const gamma = F.mul(a[1],b[0]);
    const delta = F.mul(
        F.sub(a[1], F.mul(exports.A, a[0])),
        F.add(b[0], b[1])
    );
    const tau = F.mul(beta, gamma);
    const dtau = F.mul(exports.D, tau);

    res[0] = F.div(
        F.add(beta, gamma),
        F.add(bigInt.one, dtau)
    );

    res[1] = F.div(
        F.add(delta, F.sub(F.mul(exports.A,beta), gamma)),
        F.sub(bigInt.one, dtau)
    );

    return res;
}

function mulPointEscalar(base, e) {
    let res = [bigInt("0"),bigInt("1")];
    let rem = bigInt(e);
    let exp = base;

    while (! rem.isZero()) {
        if (rem.isOdd()) {
            res = addPoint(res, exp);
        }
        exp = addPoint(exp, exp);
        rem = rem.shiftRight(1);
    }

    return res;
}

function inSubgroup(P) {
    if (!inCurve(P)) return false;
    const res= mulPointEscalar(P, exports.subOrder);
    return (res[0].equals(bigInt(0))) && (res[1].equals(bigInt(1)));
}

function inCurve(P) {
    const F = new ZqField(exports.p);

    const x2 = F.square(P[0]);
    const y2 = F.square(P[1]);

    if (!F.eq(
        F.add(F.mul(exports.A, x2), y2),
        F.add(F.one, F.mul(F.mul(x2, y2), exports.D)))) return false;

    return true;
}

function packPoint(P) {
    const buff = utils.leInt2Buff(P[1], 32);
    if (P[0].greater(exports.p.shiftRight(1))) {
        buff[31] = buff[31] | 0x80;
    }
    return buff;
}

function unpackPoint(_buff) {
    const F = new ZqField(exports.p);

    const buff = Buffer.from(_buff);
    let sign = false;
    const P = new Array(2);
    if (buff[31] & 0x80) {
        sign = true;
        buff[31] = buff[31] & 0x7F;
    }
    P[1] = utils.leBuff2int(buff);
    if (P[1].greaterOrEquals(exports.p)) return null;

    const y2 = F.square(P[1]);

    let x = F.sqrt(F.div(
        F.sub(F.one, y2),
        F.sub(exports.A, F.mul(exports.D, y2))));

    if (x == null) return null;

    if (sign) x = F.neg(x);

    P[0] = x;

    return P;
}
