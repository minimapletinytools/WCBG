pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/GSN/Context.sol";
import "./FixidityLib.sol";
import "./PotatoERC20.sol";
import "./PotatoERC721.sol";
import "./AnimalERC721.sol";
import "./AnimalLib.sol";



/// @title Government
contract Government is Context {
  // definitions
  enum Resources {
    POTATOES,
    CORN,
    CHEESE
  }
  uint constant public NUMRESOURCES = 3;
  using SafeMath for uint256;
  event Potato();

  // data

  // setup period flag
  bool isInit;

  // mapping from tokenId to AnimalData
  mapping(uint256 => AnimalLib.AnimalData) animalDataMap;

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
  constructor() public {
    DELETE_test_ctor();
    //createResourcesAndAssets();
  }

  function canInit() public returns (bool) {
    // TODO require only to be called from setup account
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

  function _levyTax(address corp, int256 f_tax, int256 f_amount, uint256 blocks) internal {
    if(f_tax == 0 || f_amount == 0 || blocks == 0) {
      return;
    }
    // there is some round off error, prob not a big deal
    // TODO
    int256 f_taxPerBlock = FixidityLib.multiply(f_tax, f_amount);
    int256 f_taxAmount =  FixidityLib.multiply(f_taxPerBlock, FixidityLib.newFixed(int256(blocks)));
    _basicTax(corp, f_taxAmount);
  }

  function _basicTax(address corp, int256 f_amount) internal {
    //int256 amount = FixidityLib.fromFixed(f_amount);
    int256 amount;
    assert(amount > 0);
    _transferToGov(corp, uint256(amount));
  }

  ///////////////////////////////
  // ANIMAL assets
  ///////////////////////////////
  function SetAnimalPrice(uint256 animal) public {
    address owner = animalC.ownerOf(animal);
    require( owner == _msgSender());
    AnimalLib.AnimalData storage data = animalDataMap[animal];
    _taxAnimal(data, owner);
  }

  // animal internal functions
  function _taxAnimal(AnimalLib.AnimalData storage data, address owner) internal {
      uint256 numBlocks = block.number - data.lastTaxUpdate;
      // TODO set tax
      //int256 tax = FixidityLib.newFixed(0);
      //uint256 value = FixidityLib.newFixed(data.value);
      _levyTax(owner, 0, 0, numBlocks);
      data.lastTaxUpdate = block.number;
  }

  ///////////////////////////////
  // ANIMAL operations
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
    return true;
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
