const babyJub = require("./babyjub.js");
const bigInt = require("big-integer");
const createBlakeHash = require("blake-hash");
const assert = require("assert");
const utils = require("./utils.js");
const poseidon = require("./poseidon").createHash(6, 8, 57);
const ZqField = require("fflib").ZqField; 

const Fs = new ZqField(babyJub.subOrder);
const hash = (...x)=> poseidon(x);

exports.proof = proof;
exports.verify = verify;




function nonce(x, H) {
  return utils.leBuff2int(createBlakeHash("blake512").
    update(Buffer.concat([utils.leInt2Buff(x, 32), utils.leInt2Buff(H, 32)])).
    digest().slice(0,32)).mod(babyJub.subOrder);
}

function proof(x, alpha) {
  assert(alpha.geq(bigInt.zero) && alpha.lesser(babyJub.p));

  const Q = babyJub.mulPointEscalar(babyJub.Base8, x);
  
  const H = babyJub.SWUSelect(hash(Q[0], alpha));
  
  const gamma = babyJub.mulPointEscalar(H, x);
  const k = nonce(x, H[0]);

  const kg = babyJub.mulPointEscalar(babyJub.Base8, k);
  const kH = babyJub.mulPointEscalar(H, k);
  const c = hash(H[0], gamma[0], kg[0], kH[0]);
  s = Fs.add(k, Fs.mul(c, x));
  return [gamma, c, s];
}


function verify(Q, alpha, gamma, c, s) {
  Q = babyJub.subgroupDecompress(Q);
  const H = babyJub.SWUSelect(hash(Q[0], alpha));
  const mc = Fs.neg(Fs.normalize(c));
  const u = babyJub.addPoint(
    babyJub.mulPointEscalar(babyJub.Base8, s), 
    babyJub.mulPointEscalar(Q, mc)
  );
  const v = babyJub.addPoint(
    babyJub.mulPointEscalar(H, s), 
    babyJub.mulPointEscalar(gamma, mc)
  );
  return c.eq(hash(H[0], gamma[0], u[0], v[0]));
}