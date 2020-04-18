const Poseidon = require("./poseidon");

const hash = Poseidon.createHash(6, 8, 57);

exports.hash0 = function (left, right) {
    return hash([left, right]);
};

exports.hash1 = function(key, value) {
    return hash([key, value, Poseidon.F.one]);
};

exports.F = Poseidon.F;
