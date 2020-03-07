var Government = artifacts.require("Government");
var PotatoERC20 = artifacts.require("PotatoERC20");

// deploy test vyper contract
module.exports = function(deployer) {
  deployer.deploy(Government).then(function() {
    // deploy test token contract, eventually this will be deployed by gov contract maybe...
    return deployer.deploy(PotatoERC20, Government.address);
  });
};
