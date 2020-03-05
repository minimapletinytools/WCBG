var VyperStorage = artifacts.require("VyperStorage");
var PotatoTesting = artifacts.require("PotatoTesting");
var PotatoLibrary = artifacts.require("PotatoLibrary");

// deploy test vyper contract
module.exports = function(deployer) {
  deployer.deploy(VyperStorage);

  deployer.deploy(PotatoLibrary);
  deployer.link(PotatoLibrary, PotatoTesting);
  // or just
  // deployer.autolink();
  deployer.deploy(PotatoTesting);
};
