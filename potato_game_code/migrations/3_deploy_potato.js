var Helper = artifacts.require("Helper");
var Government = artifacts.require("Government");
var PotatoERC20 = artifacts.require("PotatoERC20");
var PotatoERC721 = artifacts.require("PotatoERC721");
var FixidityLib = artifacts.require("FixidityLib");
var AnimalLib = artifacts.require("AnimalLib");
var PolicyLib = artifacts.require("PolicyLib");

const operator = "0x515854762Aa39c9FAeF4be59134F55894e68539f";
function logGasUsed(gasUsed, name) {
  s = name + ": ";
  s += " gasUsed: " + gasUsed;
  s += " total: %" + gasUsed/10000000*100;
  console.log(s);
}

async function logGasContract(instance) {
  txr = await web3.eth.getTransactionReceipt(instance.transactionHash)
  const gasUsed = parseInt(txr.gasUsed);
  logGasUsed(gasUsed, instance.constructor._json.contractName);
}

module.exports = function(deployer) {
  // deploy libraries
  deployer.deploy(Helper);
  deployer.deploy(FixidityLib);
  deployer.deploy(AnimalLib);
  deployer.deploy(PolicyLib);

  // link libraries
  deployer.link(AnimalLib, Government);
  deployer.link(FixidityLib, Government);
  deployer.link(PolicyLib, Government);

  // deploy government
  deployer.deploy(Government, operator, {gas: 200000000}).then(async function(gov) {
    await logGasContract(gov);

    // deploy token contracts
    const _nr = await gov.NUMRESOURCES()
    let nr = parseInt(_nr);
    let resources = new Array(nr);
    for(let i = 0; i < parseInt(nr); i++){
      inst = await deployer.deploy(PotatoERC20, Government.address);
      resources[i] = inst.address;
    }
    let debtInst = await deployer.deploy(PotatoERC20, Government.address);
    let voiceInst = await deployer.deploy(PotatoERC20, Government.address);
    let landInst = await deployer.deploy(PotatoERC721, Government.address);
    let animalInst = await deployer.deploy(PotatoERC721, Government.address);

    // connect them
    await gov.connectTokenContracts(resources, debtInst.address, voiceInst.address, landInst.address, animalInst.address);

    // run genesis
    tx = await gov.genesis();
    logGasUsed(parseInt(tx.receipt.gasUsed), "genesis");

    // deploy test token contracts
    erc20 = await deployer.deploy(PotatoERC20, Government.address);
    erc721 = await deployer.deploy(PotatoERC721, Government.address);
    await logGasContract(erc20);
    await logGasContract(erc721);

    //block = await web3.eth.getBlock();
    //console.log("block gas limit: " + parseInt(block.gasLimit));
  });
};
