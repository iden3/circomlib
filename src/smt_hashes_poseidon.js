const poseidon = require("./poseidon");

exports.hash0 = function (left, right) {
    return poseidon([left, right]);
};

exports.hash1 = function(key, value) {
    return poseidon([key, value, poseidon.F.one]);
};

exports.F = poseidon.F;
