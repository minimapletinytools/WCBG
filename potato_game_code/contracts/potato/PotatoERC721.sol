pragma solidity =0.5.16;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Government.sol";


/**
 * ERC721 for assets
 */
contract PotatoERC721 is ERC721 {
  Government government;

  constructor(address _gov) public {
    government = Government(_gov);
  }

  // TODO handle taxes before outside transfer
  // modified `transferFrom` that checks if law allows corporation to directly transfer tokens
  function transferFrom(address from, address to, uint256 tokenId) public {
    require(government.allowOutsideAssetTransfer(address(this)));
    return super.transferFrom(from, to, tokenId);
  }

  // TODO handle taxes before outside transfer
  // modified `safeTransferFrom` that checks if law allows corporation to directly transfer tokens
  function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
    require(government.allowOutsideAssetTransfer(address(this)));
    _safeTransferFrom(from, to, tokenId, _data);
  }

  function govMint(address to, uint256 tokenId) public {
    require(address(government) == _msgSender());
    super._safeMint(to, tokenId);
  }
}
