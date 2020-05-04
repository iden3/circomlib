const Poseidon = require("../../hash_functions/poseidon/js/poseidon");
const bigInt = require("big-integer");

const hash = Poseidon.createHash(6, 8, 57);

exports.hash0 = function (left, right) {
    return hash([left, right]);
};

exports.hash1 = function(key, value) {
    return hash([key, value, bigInt.one]);
};
