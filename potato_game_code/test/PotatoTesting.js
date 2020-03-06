const VyperTesting = artifacts.require("VyperTesting");
const SolidityTesting = artifacts.require("SolidityTesting");

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
  });
});
