pragma solidity =0.5.16;

import "./Government.sol";
import "./PotatoERC721.sol";


/**
 * Animal assets
 */
contract AnimalERC721 is PotatoERC721 {
  constructor(address _gov) PotatoERC721(_gov) public {
  }
}
