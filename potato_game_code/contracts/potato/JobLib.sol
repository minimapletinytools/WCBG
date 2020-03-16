pragma solidity ^0.6.0;

import "./Government.sol";



library JobLib {
  uint256 constant public NULLID = 0;

  struct Job {
    uint256 wage;
  }
  struct Employee {
    // landId of NULLID means not employed
    uint256 landId;
    uint8 jobIndex;
    uint256 lastWorkUpdate;
  }
}
