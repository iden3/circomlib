const bn128 = require("snarkjs").bn128;
const bigInt = require("snarkjs").bigInt;
const createBlakeHash = require("blake-hash");
const assert = require("assert");

function addPoint(a,b, q) {
    const cta = bigInt("168700");
    const d = bigInt("168696");

    const res = [];
    res[0] = bigInt((a[0]*b[1] + b[0]*a[1]) *  bigInt(bigInt("1") + d*a[0]*b[0]*a[1]*b[1]).inverse(q)).affine(q);
    res[1] = bigInt((a[1]*b[1] - cta*a[0]*b[0]) * bigInt(bigInt("1") - d*a[0]*b[0]*a[1]*b[1]).inverse(q)).affine(q);
    return res;
}

function mulPointEscalar(base, e, q) {
    let res = [bigInt("0"),bigInt("1")];
    let rem = bigInt(e);
    let exp = base;

    while (! rem.isZero()) {
        if (rem.isOdd()) {
            res = addPoint(res, exp, q);
        }
        exp = addPoint(exp, exp, q);
        rem = rem.shr(1);
    }

    return res;
}

function getPoint(S) {
    const F = bn128.Fr;
    const h = createBlakeHash("blake256").update(S).digest();

    assert(h.length == 32);

    let sign = false;
    if (h[31] & 0x80) {
        h[31] = h[31] & 0x7F;
        sign = true;
    }

    let y = bigInt(0);
    for (let i=0; i<32; i++) {
        y = y.shl(8);
        y = y.add(bigInt(h[i]));
    }

    const a = bigInt("168700");
    const d = bigInt("168696");

    const y2 = F.square(y);

    let x = F.sqrt(F.div(
        F.sub(F.one, y2),
        F.sub(a, F.mul(d, y2))));

    if (x == null) return null;

    if (sign) x = F.neg(x);

    const p = [bn128.Fr.affine(x), bn128.Fr.affine(y)];

    const p8 =mulPointEscalar(p, 8, bn128.r);

    return p8;
}


function generatePoint(S) {
    let p= null;
    let idx = 0;
    while (p==null) {
        let sidx = "" + idx;
        while (sidx.length<16) sidx = "0"+sidx;
        p = getPoint(S+"_"+sidx);
        idx++;
    }
    assert(inCurve(p), "Point not in curve");
    return p;
}



const r = bigInt("21888242871839275222246405745257275088614511777268538073601725287587578984328").shr(3);
function isLowGrade(p) {
    const res= mulPointEscalar(p, r, bn128.r);
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

const g = [
    bigInt("17777552123799933955779906779655732241715742912184938656739573121738514868268"),
    bigInt("2626589144620713026669568689430873010625803728049924121243784502389097019475")];


if (!inCurve(g)) {
    throw new Error("Generator not In curve -> Some thing goes wrong...");
}

for (let i=0; i<25; i++) {
    let S = "" +i;
    while (S.length<16) S = "0"+S;
    const P = generatePoint("Iden3_PedersenGenerator_"+S);
    console.log(`[${P[0].toString()}, ${P[1].toString()}]`);
}



