const truffleAssert = require('truffle-assertions');

const VyperTesting = artifacts.require("VyperTesting");
const SolidityTesting = artifacts.require("SolidityTesting");

contract("accounts", accounts => {
  it("... should do ERC20 things", async () => {
    //console.log(accounts);
    accounts.forEach(function(acc, i) {
      //web3.eth.getBalance(acc).then(function(b){console.log(b);});
    });
  });
});


contract("VyperTesting", () => {
  it("...should store the value 89.", async () => {
    const storage = await VyperTesting.deployed();

    // Set value of 89
    await storage.set(89);

    // Get stored value
    const storedData = await storage.get();

    assert.equal(storedData, 89, "The value 89 was not stored.");
  });
});

contract("SolidityTesting", () => {
  console.log("🥔🥔🥔")
  it("...handles truffle-assertion stuff as expected", async () => {
    const testContract = await SolidityTesting.deployed();

    truffleAssert.fails(
      testContract.testRevert(),
      truffleAssert.ErrorType.REVERT,
      "testing"
    );

    var num = 5;
    var result = await testContract.testEvent(num);
    //console.log(result);
    //result.logs.forEach(l => console.log(l.args));
    // there's a better way to test for BNs...
    truffleAssert.eventEmitted(result, 'MyTestEvent', (ev) => {
      return ev[0].toString() == num;
    });
  });

  it("...should store the value 89.", async () => {
    const storage = await SolidityTesting.deployed();

    var storeVal = 89;
    var balanceVal = 100;

    await storage.store(storeVal, { value: balanceVal } );

    // Get stored value
    var v = await storage.retrieve();

    v0 = v[0].toString();
    v1 = v[1].toString();
    v2 = v[2].toString();
    v3 = v[3].toString();

    assert.equal(v0, storeVal, "The value 89 was not stored.");
    assert.equal(v1, storeVal, "The value 89 was not stored.");
    assert.equal(v2, storeVal, "The value 89 was not stored.");
    assert.equal(v3, balanceVal, "The value 0 was not stored.");

    var sender = await storage.getSender();
    var senderLibrary = await storage.getSenderFromLibraryTesting();
    assert.equal(senderLibrary, sender, "the senders should be the same.");

    num = await storage.ctorNum()
    assert.equal(12, num, "ctor number should be 12")
  });
});
