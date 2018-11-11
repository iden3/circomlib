const bn128 = require("snarkjs").bn128;
const bigInt = require("snarkjs").bigInt;
const createBlakeHash = require("blake-hash");
const assert = require("assert");

function getPoint(S) {
    const F = bn128.Fr;
    const h = createBlakeHash("blake256").update(S).digest();

    assert(h.length == 32);

    let sign = false;
    if (h[31] & 0x80) {
        h[31] = h[31] & 0x7F;
        sign = true;
    }

    let x = bigInt(0);
    for (let i=0; i<32; i++) {
        x = x.shl(8);
        x = x.add(bigInt(h[i]));
    }

    const a = bigInt("168700");
    const d = bigInt("168696");

    const x2 = F.square(x);

    let y = F.sqrt(F.div(
        F.sub(F.one, F.mul(a, x2)),
        F.sub(F.one, F.mul(d, x2))));

    if (y == null) return null;

    if (sign) y = F.neg(y);

    return [bn128.Fr.affine(x), bn128.Fr.affine(y)];
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
    assert(inCurve(p));
    return p;
}

function inCurve(p) {
    const F = bn128.Fr;

    const a = bigInt("168700");
    const d = bigInt("168696");

    const x2 = F.square(p[0]);
    const y2 = F.square(p[1]);

    return F.equals(
        F.add(F.mul(a, x2), y2),
        F.add(F.one, F.mul(F.mul(x2, y2), d)));
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



