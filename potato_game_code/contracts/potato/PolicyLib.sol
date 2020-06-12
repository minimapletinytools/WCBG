pragma solidity =0.5.16;


library PolicyLib {
  struct Policy {
    uint256 voice_per_animal_per_block;
  }

  function initializeDefaultPolicy(Policy storage policy) internal {
    policy.voice_per_animal_per_block = 1000;
  }
}
