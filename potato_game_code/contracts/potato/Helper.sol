pragma solidity ^0.6.0;

contract Helper {
  function codeSize(address _addr) public view returns (uint256 o_code) {
    assembly {
      o_code := extcodesize(_addr)
    }
  }
}
