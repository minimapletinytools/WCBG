pragma solidity =0.5.16;

import "./JobLib.sol";

library LandLib {
  struct LandData {
    string name;
    uint256 value;
  
    JobLib.Job[] jobs;
    uint256[] employees;

    uint256 lastUpdate;
    uint256 lastTaxUpdate;
  }
}
