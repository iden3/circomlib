const chai = require("chai");
const path = require("path");

const Fr = require("ffjavascript").bn128.Fr;
const tester = require("circom").tester;

const babyJub = require("../src/babyjub.js");

const PBASE =
    [
        [Fr.e("7688621503272331394947188562469131124099290577812125474996268020905176040083"),Fr.e("6637287939860384587467947982369268811366630904563077767287326262235485629411")],
        [Fr.e("11549681895645637778324638856880330712650895608496649854094912415387988201330"),Fr.e("5771732722784528537721081267383956005090479808901717812009343940574217488577")],
        [Fr.e("18790245153471844934157747708238883966079935875787657036767664036124524381945"),Fr.e("18300275459419441151064576487317481499516933849631632883767173501999997278432")],
        [Fr.e("16301069151422548986850494139112207641738464387919729729324473657161689764196"),Fr.e("8215273507373494014441104012907835625670941526105528197815397741007626226499")],
        [Fr.e("12597665704678284488008395353749282149622295037737374782196049599390683534185"),Fr.e("4072455241781501621593714139281767473040087753548015968773801065193764079468")]
    ];

describe("Double Pedersen test", function() {
    let circuit;
    this.timeout(100000);
    before( async() => {

        circuit = await tester(path.join(__dirname, "circuits", "pedersen_test.circom"));

    });
    it("Should pedersen at zero", async () => {

        let w;

        w = await circuit.calculateWitness({ in: ["0", "0"]}, true);

        await circuit.assertOut(w, {out: [0,1]});

    });
    it("Should pedersen at one first generator", async () => {
        let w;

        w = await circuit.calculateWitness({ in: ["1", "0"]}, true);

        await circuit.assertOut(w, {out: PBASE[0]});

    });
    it("Should pedersen at one second generator", async () => {
        let w;

        w = await circuit.calculateWitness({ in: ["0", "1"]}, true);

        await circuit.assertOut(w, {out: PBASE[1]});

    });
    it("Should pedersen at mixed generators", async () => {
        let w;
        w = await circuit.calculateWitness({ in: ["3", "7"]}, true);

        const r = babyJub.addPoint(
            babyJub.mulPointEscalar(PBASE[0], 3),
            babyJub.mulPointEscalar(PBASE[1], 7)
        );

        await circuit.assertOut(w, {out: r});

    });
    it("Should pedersen all ones", async () => {
        let w;

        const allOnes = Fr.sub(Fr.shl(Fr.e("1"), Fr.e(250)), Fr.e("1"));
        w = await circuit.calculateWitness({ in: [allOnes, allOnes]}, true);


        const r2 = babyJub.addPoint(
            babyJub.mulPointEscalar(PBASE[0], allOnes),
            babyJub.mulPointEscalar(PBASE[1], allOnes)
        );

        await circuit.assertOut(w, {out: r2});
    });
});
