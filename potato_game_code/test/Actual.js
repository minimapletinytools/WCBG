const truffleAssert = require('truffle-assertions');

const Helper = artifacts.require("Helper");
const Government = artifacts.require("Government");
const PotatoERC20 = artifacts.require("PotatoERC20");
const PotatoERC721 = artifacts.require("PotatoERC721");

const testAnimal1 = 1;

function printGas(txr, name) {
  s = "";
  if (name) {
    s += name +": ";
  }
  // gasUsed
  s += txr.receipt.gasUsed + " ";
  // number of simple transactions
  s += Math.trunc(txr.receipt.gasUsed/21000) + " ";
  // ratio of block gas limit
  s += txr.receipt.gasUsed/10000000;
  console.log(s);
}

/* DELETE
async function setupGovernment() {
  const gov = await Government.deployed();
  try {
    r = await gov.createResourcesAndAssets({gas: 200000000 });
    printGas(r, "setupGovernment");
  } catch(error) {
    console.log(error);
  }
  return gov;
} */

async function printCapacity(contract, name) {
  const instance = await contract.deployed();
  const helper = await Helper.deployed();
  const size = await helper.codeSize(instance.address);
  console.log(instance.constructor._json.contractName + ": " + size + " bytes out of 24577 %" + size/24577 + " capacity.");
}

contract("Helper", accounts => {
  it("print code sizes", async () => {
    printCapacity(Government);
  });
});

// accounts[0] is operator account
// accounts[1] is seed account
contract("Government", accounts => {

  it("initial state test", async () => {
    const gov = await Government.deployed();
    address = await gov.potatoC();
    const potato = await PotatoERC20.at(address);
    const b0 = await potato.balanceOf(accounts[0]);
    assert(100000000, b0, "expected 100000000");
    const b1 = await potato.balanceOf(accounts[1]);
    assert(100000000, b1, "expected 100000000");

    // TODO check for ERC721
  });

  it("PotatoERC20 test", async () => {
    const gov = await Government.deployed();
    const testTokenAddress = await gov.testToken();
    const testToken = await PotatoERC20.at(testTokenAddress);
    const test_mint_rslt = await gov.DELETE_test_mint();
    assert(true, test_mint_rslt, "expected true");
    const testAddress = await gov.testAddress();
    const balance = await testToken.balanceOf(testAddress);
    assert(100, balance, "expected 100");
  });

  it("Animal", async () => {
    const gov = await Government.deployed();
    gov.SetAnimalPrice(testAnimal1, 1000, {from: accounts[0]});
    price1 = await gov.getAnimalPrice(testAnimal1);
    assert(1000, price1, "expected 1000");
    gov.PurchaseAnimal(testAnimal1, 2000, {from: accounts[1]});
    price2 = await gov.getAnimalPrice(testAnimal1);
    assert(2000, price2, "expected 2000");
  });

  it("print resource and asset addresses", async () => {
    const gov = await Government.deployed();
    const numResources = await gov.NUMRESOURCES();
    var resources = [];
    for (let i = 0; i < numResources; ++i) {
      resources[i] = await gov.resourcesC(i);
      //console.log(resources[i]);
    }
    const debt = await gov.debtC();
    const voice = await gov.voiceC();
    resources.push(debt);
    resources.push(voice);
    //console.log(resources);
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