const truffleAssert = require('truffle-assertions');

const Government = artifacts.require("Government");
const PotatoERC20 = artifacts.require("PotatoERC20");
const PotatoERC721 = artifacts.require("PotatoERC721");

async function setupGovernment() {
  console.log("hiii");
  const gov = await Government.deployed();
  try {
    await gov.createResourcesAndAssets({gas: 200000000 });
  } catch(error) {
    console.log(error);
  }
  return gov;
}


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


  it("... sets up resources and assets correctly", async () => {
    gov = await setupGovernment();

    const numResources = await gov.NUMRESOURCES();
    var resources = [];
    for (let i = 0; i < numResources; ++i) {
      resources[i] = await gov.resourcesC(i);
      console.log(resources[i]);
    }
    console.log(resources);
    const debt = await gov.debtC();
    const voice = await gov.voiceC();
    resources.push(debt);
    resources.push(voice);
    console.log(resources);
  });
});

contract("PotatoERC20", accounts => {
  it("... has restricted access on its methods", async () => {
    const token = await PotatoERC20.deployed();
    truffleAssert.fails(
      token.govMint(accounts[0], 10),
      truffleAssert.ErrorType.REVERT
    );
  });
});

contract("PotatoERC721", accounts => {
  it("... has restricted access on its methods", async () => {
    const token = await PotatoERC721.deployed();
    truffleAssert.fails(
      token.transferFrom(accounts[0], accounts[1], 0),
      truffleAssert.ErrorType.REVERT
    );
  });
});
