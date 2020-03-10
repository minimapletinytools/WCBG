var Government = artifacts.require("Government");
var PotatoERC20 = artifacts.require("PotatoERC20");
var PotatoERC721 = artifacts.require("PotatoERC721");
var FixidityLib = artifacts.require("FixidityLib");
var AnimalLib = artifacts.require("AnimalLib");

// deploy test vyper contract
module.exports = function(deployer) {
  deployer.deploy(FixidityLib);
  deployer.deploy(AnimalLib);
  deployer.link(AnimalLib, Government);
  deployer.link(FixidityLib, Government);

  deployer.deploy(Government).then(async function(gov) {
    console.log(gov.transactionHash);
    txr = await web3.eth.getTransactionReceipt(gov.transactionHash)
    console.log(txr);

    // deploy test token contract, eventually this will be deployed by gov contract maybe...
    erc20 = await deployer.deploy(PotatoERC20, Government.address);
    erc20txr = await web3.eth.getTransactionReceipt(erc20.transactionHash)
    erc721 = await deployer.deploy(PotatoERC721, Government.address);
    erc721txr = await web3.eth.getTransactionReceipt(erc721.transactionHash)
    console.log("erc20 gas: " + parseInt(erc20txr.gasUsed));
    console.log("erc721 gas: " + parseInt(erc721txr.gasUsed));

    block = await web3.eth.getBlock();
    console.log("block gas limit: " + parseInt(block.gasLimit));
  });
};
