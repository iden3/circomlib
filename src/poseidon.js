const poseidonPerm = require("./poseidonPerm");

function poseidon(inputs) {
    return poseidonPerm([0, ...inputs])[0];
}

module.exports = poseidon;
