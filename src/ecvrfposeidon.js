const babyJub = require("./babyjub.js");
const bigInt = require("big-integer");
const createBlakeHash = require("blake-hash");
const assert = require("assert");
const utils = require("./utils.js");
const poseidon = require("./poseidon").createHash(6, 8, 57);


exports.proof = proof;
exports.verify = verify;

function hash(x, size) {
  return babyJub.unpackPoint(pedersen.hash(utils.leInt2Buff(x, Math.ceil(size/8)), size));
}


function nonce(x, H) {
  x = bigInt(x);
  H = bigInt(H);
  return bigInt.leBuff2int(createBlakeHash("blake512").
    update(Buffer.concat([utils.leInt2Buff(x, 32), utils.leInt2Buff(H, 32)])).
    digest().slice(0,32)).affine(babyJub.subOrder);
}

function proof(x, alpha) {
  x = bigInt(x);
  alpha = bigInt(alpha);
  assert((alpha >= bigInt.zero) && (alpha < babyJub.p));

  const Q = babyJub.mulPointEscalar(babyJub.Base8, x);
  const H = hash(Q[0].add(alpha.shl(bigInt(254))), 508);
  const gamma = babyJub.mulPointEscalar(H, x);
  const k = nonce(x, H[0]);

  const kg = babyJub.mulPointEscalar(babyJub.Base8, k);
  const kH = babyJub.mulPointEscalar(H, k);
  const c = hash(H[0].add(gamma[0].shl(bigInt(254))).add(kg[0].shl(bigInt(508))).add(kH[0].shl(bigInt(762))), 1016)[0];
  s = k.add(c.mul(x)).affine(babyJub.subOrder);

  return [gamma[0], c, s];
}


function verify(Q, alpha, gamma, c, s) {
  Q = babyJub.subgroupDecompress(bigInt(Q));
  gamma = babyJub.subgroupDecompress(bigInt(gamma));
  const H = hash(Q[0].add(alpha.shl(bigInt(254))), 508);
  const u = babyJub.addPoint(babyJub.mulPointEscalar(babyJub.Base8, s), babyJub.mulPointEscalar(Q, c.neg(babyJub.subOrder).affine(babyJub.subOrder) ));
  const v = babyJub.addPoint(babyJub.mulPointEscalar(H, s), babyJub.mulPointEscalar(gamma, c.neg(babyJub.subOrder).affine(babyJub.subOrder) ));
  return c == (hash(H[0].add(gamma[0].shl(bigInt(254))).add(u[0].shl(bigInt(508))).add(v[0].shl(bigInt(762))), 1016)[0]);
}