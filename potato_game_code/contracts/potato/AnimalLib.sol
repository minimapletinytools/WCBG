pragma solidity =0.5.16;

import "./JobLib.sol";

library AnimalLib {
  uint256 constant public NULLID = 0;

  struct AnimalData {
    string name;
    uint256 value;

    uint256 lastUpdate;
    uint256 lastTaxUpdate;

    JobLib.Employee employed;
  }

  function isEmployed(AnimalData storage data) public view returns (bool) {
    return data.employed.landId == NULLID;
  }
}
