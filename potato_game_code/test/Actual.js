const truffleAssert = require('truffle-assertions');

const Government = artifacts.require("Government");
const PotatoERC20 = artifacts.require("PotatoERC20");


contract("Government", accounts => {
  it("... has proper authority over PotatoERC20", async () => {
    const gov = await Government.deployed();
    const testTokenAddress = await gov.testToken();
    const testToken = await PotatoERC20.at(testTokenAddress);
    const test_mint_rslt = await gov.DELETE_test_mint();
    assert(true, test_mint_rslt, "expected true");
    const testAddress = await gov.testAddress();
    const balance = await testToken.balanceOf(testAddress);
    assert(100, balance, "expected 100");

  });
});

contract("PotatoERC20", accounts => {
  it("... should do ERC20 things", async () => {

  });
});
