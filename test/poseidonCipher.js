const chai = require("chai");
const ZqField = require("ffjavascript").ZqField;
const Scalar = require("ffjavascript").Scalar;
const assert = chai.assert;

const poseidonCipher = require("../src/poseidonCipher.js");
const F = new ZqField(Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617"));

function testEncryptDecrypt(message) {
  const key = [F.e("123"), F.e("456")];
  const ciphertext = poseidonCipher.encrypt(message, key, 0);

  const decrypted = poseidonCipher.decrypt(ciphertext, key, 0, message.length);
  assert(decrypted.length === message.length);
  for (let i = 0; i < decrypted.length; i ++) {
    assert(F.e(decrypted[i]) === F.e(message[i]));
  }
}

describe("Poseidon encryption and decryption", function () {
    it("Encryption and decryption with Poseidon", async () => {
      testEncryptDecrypt([1]);
      testEncryptDecrypt([1, 2]);
      testEncryptDecrypt([1, 2, 3]);
      testEncryptDecrypt([1, 2, 3, 4]);
      testEncryptDecrypt([1, 2, 3, 4, 5]);
      testEncryptDecrypt([1, 2, 3, 4, 5, 6]);
      testEncryptDecrypt([1, 2, 3, 4, 5, 6, 7]);
    });
});
