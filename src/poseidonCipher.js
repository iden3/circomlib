const assert = require("assert");
const Scalar = require("ffjavascript").Scalar;
const ZqField = require("ffjavascript").ZqField;
const poseidonPerm = require("./poseidonPerm");

// Prime 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001
const F = new ZqField(Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617"));

const two128 = F.e("340282366920938463463374607431768211456");

function encrypt(msg, key, nonce) {
    assert(Array.isArray(msg));
    assert(Array.isArray(key));
    assert(key.length === 2);
    msg = msg.map((x) => F.e(x));

    // The nonce must be less than 2 ^ 128
    assert(nonce < two128);

    const message = [...msg];

    // Pad the message if needed
    while (message.length % 3 > 0) {
        message.push(F.zero);
    }

    let cipherLength = message.length;

    // Create the initial state
    let state = [
        F.zero,
        F.e(key[0]),
        F.e(key[1]),
        F.add(
            F.e(nonce), 
            F.mul(F.e(msg.length), two128),
        ),
    ];

    const ciphertext = [];

    for (let i = 0; i < cipherLength / 3; i ++) {
        // Iterate Poseidon on the state
        state = poseidonPerm(state);

        // Absorb three elements of message
        state[1] = F.add(state[1], F.e(message[i * 3]));
        state[2] = F.add(state[2], F.e(message[i * 3 + 1]));
        state[3] = F.add(state[3], F.e(message[i * 3 + 2]));
        
        // Release three elements of the ciphertext
        ciphertext.push(state[1]);
        ciphertext.push(state[2]);
        ciphertext.push(state[3]);
    }

    // Iterate Poseidon on the state one last time
    state = poseidonPerm(state);

    // Release the last ciphertext element
    ciphertext.push(state[1]);

    return ciphertext;
}

function decrypt(ciphertext, key, nonce, length) {
    assert(Array.isArray(ciphertext));
    assert(Array.isArray(key));
    assert(key.length === 2);

    // Create the initial state
    let state = [
        F.zero,
        F.e(key[0]),
        F.e(key[1]),
        F.add(
            F.e(nonce), 
            F.mul(F.e(length), two128),
        ),
    ];

    const message = [];

    let n = Math.floor(ciphertext.length / 3);

    for (let i = 0; i < n; i ++) {
        // Iterate Poseidon on the state
        state = poseidonPerm(state);

        // Release three elements of the message
        message.push(F.sub(ciphertext[i * 3], state[1]));
        message.push(F.sub(ciphertext[i * 3 + 1], state[2]));
        message.push(F.sub(ciphertext[i * 3 + 2], state[3]));

        // Modify the state
        state[1] = ciphertext[i * 3];
        state[2] = ciphertext[i * 3 + 1];
        state[3] = ciphertext[i * 3 + 2];
    }

    // If length > 3, check if the last (3 - (l mod 3)) elements of the message
    // are 0
    if (length > 3) {
        if (length % 3 === 2) {
            assert(F.eq(message[message.length - 1], F.zero));
        } else if (length % 3 === 1) {
            assert(F.eq(message[message.length - 1], F.zero));
            assert(F.eq(message[message.length - 2], F.zero));
        }
    }

    // Iterate Poseidon on the state one last time
    state = poseidonPerm(state);

    // Check the last ciphertext element
    assert(F.eq(ciphertext[ciphertext.length - 1], state[1]));

    return message.slice(0, length);
}

module.exports = { encrypt, decrypt };
