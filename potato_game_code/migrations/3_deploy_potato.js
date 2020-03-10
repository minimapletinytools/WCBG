var Helper = artifacts.require("Helper");
var Government = artifacts.require("Government");
var PotatoERC20 = artifacts.require("PotatoERC20");
var PotatoERC721 = artifacts.require("PotatoERC721");
var FixidityLib = artifacts.require("FixidityLib");
var AnimalLib = artifacts.require("AnimalLib");

async function logGas(instance, name) {
  s = "";
  s += instance.constructor._json.contractName + ": "
  txr = await web3.eth.getTransactionReceipt(instance.transactionHash)
  s += " gasUsed: " + parseInt(txr.gasUsed);
  console.log(s);
}

module.exports = function(deployer) {
  // deploy libraries
  deployer.deploy(Helper);
  deployer.deploy(FixidityLib);
  deployer.deploy(AnimalLib);

  // link libraries
  deployer.link(AnimalLib, Government);
  deployer.link(FixidityLib, Government);

  // deploy government
  deployer.deploy(Government, {gas: 200000000}).then(async function(gov) {
    await logGas(gov);

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

    // deploy test token contracts, eventually this will be deployed by gov contract maybe...
    erc20 = await deployer.deploy(PotatoERC20, Government.address);
    erc721 = await deployer.deploy(PotatoERC721, Government.address);
    await logGas(erc20);
    await logGas(erc721);

    block = await web3.eth.getBlock();
    console.log("block gas limit: " + parseInt(block.gasLimit));
  });
};
