pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./PotatoERC20.sol";

/// @title Government
contract Government {
    using SafeMath for uint256;


    event Potato();

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
}
