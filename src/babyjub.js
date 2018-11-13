const bn128 = require("snarkjs").bn128;
const bigInt = require("snarkjs").bigInt;

exports.addPoint = addPoint;
exports.mulPointEscalar = mulPointEscalar;
exports.inCurve = inCurve;

function addPoint(a,b) {
    const q = bn128.r;
    const cta = bigInt("168700");
    const d = bigInt("168696");

    const res = [];
    res[0] = bigInt((a[0]*b[1] + b[0]*a[1]) *  bigInt(bigInt("1") + d*a[0]*b[0]*a[1]*b[1]).inverse(q)).affine(q);
    res[1] = bigInt((a[1]*b[1] - cta*a[0]*b[0]) * bigInt(bigInt("1") - d*a[0]*b[0]*a[1]*b[1]).inverse(q)).affine(q);
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
        rem = rem.shr(1);
    }

    return res;
}

function isLowGrade(p) {
    const r = bigInt("21888242871839275222246405745257275088614511777268538073601725287587578984328").shr(3);
    const res= mulPointEscalar(p, r);
    return (res[0].equals(bigInt(0))) && (res[1].equals(bigInt(1)));
}

function inCurve(p) {
    const F = bn128.Fr;

    const a = bigInt("168700");
    const d = bigInt("168696");

    const x2 = F.square(p[0]);
    const y2 = F.square(p[1]);

    if (!F.equals(
        F.add(F.mul(a, x2), y2),
        F.add(F.one, F.mul(F.mul(x2, y2), d)))) return false;

    if (!isLowGrade(p)) return false;

    return true;
}
