pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/GSN/Context.sol";
import "./FixidityLib.sol";
import "./CommonLib.sol";
import "./PolicyLib.sol";
import "./PotatoERC20.sol";
import "./PotatoERC721.sol";
import "./AnimalERC721.sol";
import "./AnimalLib.sol";


/// @title Government
contract Government is Context {
  using SafeMath for uint256;

  event Potato();

  // sadly, these can not be accessed from another contract :(
  uint256 constant public NUMRESOURCES = 3;
  uint256 constant public NULLASSET = 0;

  ///////////////////////////////
  // DATA
  ///////////////////////////////

  // setup params
  bool isInit;
  address operator;
  address seedAccount;

  // mapping from tokenId to AnimalData
  mapping(uint256 => AnimalLib.AnimalData) animalDataMap;

  PolicyLib.Policy policy;

  // token addresses
  PotatoERC20[] public resourcesC = new PotatoERC20[](NUMRESOURCES);
  PotatoERC20 public potatoC;
  PotatoERC20 public voiceC;
  PotatoERC20 public debtC; // debt is not actually fungible. The collataral situation is also not so clear.
  PotatoERC721 public landC;
  AnimalERC721 public animalC;

  ///////////////////////////////
  // SETUP
  ///////////////////////////////
  constructor(address _operator, address _seedAccount) public {
    operator = _operator;
    seedAccount = _seedAccount;
    DELETE_test_ctor();

    PolicyLib.initializeDefaultPolicy(policy);
  }

  function canInit() public returns (bool) {
    require(_msgSender() == operator);
    return !isInit;
  }

  function connectTokenContracts(
    address[NUMRESOURCES] memory resources,
    address debtAddr,
    address voiceAddr,
    address landAddr,
    address animalAddr
  ) public {
    assert(canInit());
    for(uint i = 0; i < NUMRESOURCES; ++i) {
      resourcesC[i] = PotatoERC20(resources[i]);
    }
    potatoC = resourcesC[0];
    debtC = PotatoERC20(debtAddr);
    voiceC = PotatoERC20(voiceAddr);
    landC = PotatoERC721(landAddr);
    animalC = AnimalERC721(animalAddr);
  }

  function genesis() public {
    assert(canInit());

    // mint animals
    for(uint i = 1; i < 100; i++) {
      animalC.govMint(operator, i);
      // TODO probably need to do this is separate method to split gas
      // also set lastUpdate/lastTaxUpdate
      //animalDataMap[i] = AnimalLib.AnimalData();
    }

    // mint potatoes
    potatoC.govMint(operator, 100000000);
    potatoC.govMint(seedAccount, 100000000);
  }

  ///////////////////////////////
  // BANK HELPERS
  ///////////////////////////////
  function _transferToGov(address corp, uint256 amount) internal returns (uint256) {
    uint256 balance = potatoC.balanceOf(corp);
    if(amount > balance) {
      uint256 newDebt = amount - balance;
      potatoC.transferFrom(corp, address(this), balance);
      debtC.govMint(corp, newDebt);

      // TODO handle force bankrupcy
      // IDK if public debt exceeds total value of all assets owed, then player really goes bankrupt and relinquishes all assets to the government for auction.
      //if(master.debt > master.totalAssetValue*law.bankruptThreshold)

      // todo debt needs to be taken from public's reserve

      return newDebt;
    }
    potatoC.transferFrom(corp, address(this), amount);
    return 0;
  }

  // TODO consider embedding this into ERC20 contract
  // always transfer potatoes using this internal function such that debt is paid automatically
  function _transfer(address sender, address recipient, uint256 amount) internal {
    uint256 balance = potatoC.balanceOf(sender);
    require(balance >= amount);
    uint256 debt = debtC.balanceOf(recipient);
    uint256 toGov = Math.min(debt, amount);
    if (toGov > 0) {
      potatoC.transferFrom(sender, address(this), toGov);
    }
    if (amount - toGov > 0) {
      potatoC.transferFrom(sender, recipient, amount - toGov);
    }
  }

  function _levyTax(address corp, int256 f_tax, uint256 amount, uint256 blocks) internal {
    if(f_tax == 0 || amount == 0 || blocks == 0) {
      return;
    }

    int256 f_taxPerBlock = FixidityLib.multiply(f_tax, FixidityLib.newFixed(int256(amount)));
    int256 f_taxAmount =  FixidityLib.multiply(f_taxPerBlock, FixidityLib.newFixed(int256(blocks)));
    int256 taxAmount = FixidityLib.fromFixed(f_taxAmount);
    assert(taxAmount > 0);
    _basicTax(corp, uint256(taxAmount));
  }

  function _basicTax(address corp, uint256 amount) internal {
    assert(amount > 0);
    _transferToGov(corp, uint256(amount));
  }

  ///////////////////////////////
  // ANIMAL assets
  ///////////////////////////////
  function getAnimalPrice(uint256 animal) public view returns (uint256) {
    AnimalLib.AnimalData storage data = animalDataMap[animal];
    return data.value;
  }

  function SetAnimalPrice(uint256 animal, uint256 newValue) public {
    address owner = animalC.ownerOf(animal);
    require( owner == _msgSender());
    AnimalLib.AnimalData storage data = animalDataMap[animal];
    _taxAnimal(data, owner);
    data.value = newValue;
  }

  function PurchaseAnimal(uint256 animalId, uint256 newValue) public {
    AnimalLib.AnimalData storage animal = animalDataMap[animalId];
    address seller = animalC.ownerOf(animalId);
    address buyer = _msgSender();
    _updateAnimal(animal, seller);
    potatoC.govTransferFrom(seller, buyer, animal.value);
    animal.value = newValue;
  }

  // animal internal functions
  function _taxAnimal(AnimalLib.AnimalData storage animal, address owner) internal {
    uint256 numBlocks = block.number - animal.lastTaxUpdate;
    // TODO set tax
    int256 f_tax = FixidityLib.newFixed(0);
    _levyTax(owner, f_tax, animal.value, numBlocks);
    animal.lastTaxUpdate = block.number;
  }


  function _updateAnimal(AnimalLib.AnimalData storage animal, address owner) internal {
    uint256 numBlocks = block.number - animal.lastUpdate;

    // DELETE should be done sep
    //taxAnimal(animal);

    // give corporation VOICE
    voiceC.govMint(owner, policy.voice_per_animal_per_block * numBlocks);

    // TODO feed the animal to full
    //feedAnimal(animal, ENERGY_PER_BLOCK_BASE * numBlocks, MAX_ENERGY);

    // DELETE should be done sep
    //if(animal.job != 0) {
    //    work(animal)
    //}

    // ?? is it a problem if there are future updates in the same block#?
    // I'm pretty sure it's not
    // ?? maybe 1 action/user limitation (also means you can keep track of oldest animal more easily)
    animal.lastUpdate = block.number;
  }

  ///////////////////////////////
  // LAND assets
  ///////////////////////////////



  ///////////////////////////////
  // CALLBACKS for PotatoERC20
  ///////////////////////////////

  /// @param resource - the token address of the resource to be transfered
  /// @param msgSender - the contract attempting to transfer
  /// @return - authorized or not
  function isAuthorizedForTransfer(address resource, address msgSender) public pure returns (bool) {
    return true;
  }

  /// @param resource - the token address of the resource to be transfered
  /// @return - allowed or not
  function allowOutsideResourceTransfer(address resource) public pure returns (bool) {
    return false;
  }

  /// @param asset - the token address of the asset to be transfered
  /// @return - allowed or not
  function allowOutsideAssetTransfer(address asset) public pure returns (bool) {
    return false;
  }

  ///////////////////////////////
  // TESTING FUNCTION BELOW DELETE FOR PRODUCTION
  ///////////////////////////////

  PotatoERC20 public testToken;
  address public testAddress = address(0x12345);
  function DELETE_test_ctor() internal {
    testToken = new PotatoERC20(address(this));
  }

  function DELETE_test_mint() public returns (bool) {
    testToken.govMint(testAddress, 100);
    return true;
  }
}
