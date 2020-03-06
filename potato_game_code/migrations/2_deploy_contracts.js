var VyperTesting = artifacts.require("VyperTesting");
var SolidityTesting = artifacts.require("SolidityTesting");
var LibraryTesting = artifacts.require("LibraryTesting");

// deploy test vyper contract
module.exports = function(deployer) {
  deployer.deploy(VyperTesting);

  deployer.deploy(LibraryTesting);
  deployer.link(LibraryTesting, SolidityTesting);
  // or just
  // deployer.autolink();
  deployer.deploy(SolidityTesting);
};
