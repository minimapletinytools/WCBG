pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Government.sol";


/**
 * ERC721 for assets
 */
contract PotatoERC721 is ERC721 {
    using SafeMath for uint256;


    Government government;

    constructor(address _gov) public {
        government = Government(_gov);
    }

    // TODO handle taxes before outside transfer
    // modified `transferFrom` that checks if law allows corporation to directly transfer tokens
    function transferFrom(address from, address to, uint256 tokenId) public override {
        require(government.allowOutsideAssetTransfer(address(this)));
        return super.transferFrom(from, to, tokenId);
    }

    // TODO handle taxes before outside transfer
    // modified `safeTransferFrom` that checks if law allows corporation to directly transfer tokens
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public override {
        require(government.allowOutsideAssetTransfer(address(this)));
        _safeTransferFrom(from, to, tokenId, _data);
    }
}
