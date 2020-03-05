library PotatoLibrary {
  struct Data {
    mapping(address => int) storedValue;
    mapping(address => uint) balances;
  }
  function setValue(Data storage self, int amt) public {
    self.storedValue[msg.sender] = amt;
  }
  function getValue(Data storage self) public view returns (int) {
    return self.storedValue[msg.sender];
  }
  function setBalance(Data storage self) public {
    self.balances[msg.sender] = msg.value;
  }
  function getBalance(Data storage self) public view returns (uint) {
    return self.balances[msg.sender];
  }
  function getSender() public view returns (address) {
    return msg.sender;
  }
}
