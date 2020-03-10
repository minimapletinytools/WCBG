var Government = artifacts.require("Government");
var PotatoERC20 = artifacts.require("PotatoERC20");
var PotatoERC721 = artifacts.require("PotatoERC721");
var FixidityLib = artifacts.require("FixidityLib");

// deploy test vyper contract
module.exports = function(deployer) {
  deployer.deploy(FixidityLib);
  deployer.link(FixidityLib, Government);
  deployer.deploy(Government).then(function() {
    // deploy test token contract, eventually this will be deployed by gov contract maybe...
    deployer.deploy(PotatoERC20, Government.address);
    return deployer.deploy(PotatoERC721, Government.address);
  });
};
