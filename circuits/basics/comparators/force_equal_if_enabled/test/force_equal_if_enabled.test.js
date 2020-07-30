const chai = require("chai");
const path = require("path");
const tester = require("circom").tester;

const assert = chai.assert;

describe("Force Equal if Enabled test", function ()  {

    this.timeout(100000);

    it("Should satisfy force_equal_if_enabled", async() => {
        const circuit = await tester(path.join(__dirname, "force_equal_if_enabled.test.circom"));
        
        await circuit.calculateWitness({ "in": [333,333], "enabled": 1 }, true);
        await circuit.calculateWitness({ "in": [556,123], "enabled": 0 }, true);
    });

    it("Should NOT satisfy force_equal_if_enabled", async () => {
        
        const circuit = await tester(path.join(__dirname, "force_equal_if_enabled.test.circom"));

            try {
                await circuit.calculateWitness({ "in": [333,444], "enabled": 1 }, true);
                assert(false);
            } catch(err) {
                assert(/Constraint\sdoesn't\smatch(.*)1\s!=\s0/.test(err.message) );
    }
  
    });
});
