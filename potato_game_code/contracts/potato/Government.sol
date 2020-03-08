pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./PotatoERC20.sol";

/// @title Government
contract Government {
    using SafeMath for uint256;

    event Potato();

    constructor() public {
      DELETE_test_ctor();
    }

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

    // TESTING FUNCTION BELOW DELETE FOR PRODUCTION
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
