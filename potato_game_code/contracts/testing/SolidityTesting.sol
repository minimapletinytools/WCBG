pragma solidity =0.5.16;

import "./LibraryTesting.sol";

contract SolidityTesting {
  LibraryTesting.Data potatoLibraryData;
  mapping(address => MyNumber) public mStore;
  struct MyNumber {
    int num;
  }
  uint256 public ctorNum;

  constructor(uint256 num) public {
      ctorNum = num;
  }

  MyNumber myNumber;
  // this won't work sadly
  //function setSomeNumber(MyNumber storage myNum, int newNum) {
  //  myNum.num = newNum;
  //}
  function store(int num) public payable {
    // test storage stuff
    MyNumber storage storeNum = mStore[msg.sender];
    storeNum.num = num;

    // test more storage stuff
    //setSomeNumber(myNumber, num);
    MyNumber storage myNum = myNumber;
    myNum.num = num;

    // test library stuff
    LibraryTesting.setValue(potatoLibraryData, num);
    LibraryTesting.setBalance(potatoLibraryData);
  }
  function retrieve() public view returns (int,int,int,uint) {
    int r0 = myNumber.num;
    int r1 = mStore[msg.sender].num;
    int r2 = LibraryTesting.getValue(potatoLibraryData);
    uint r3 = LibraryTesting.getBalance(potatoLibraryData);
    return (r0, r1, r2, r3);
  }

  function getSender() public view returns (address) {
    return msg.sender;
  }
  function getSenderFromLibraryTesting() public view returns (address) {
    return LibraryTesting.getSender();
  }

  event MyTestEvent(uint256);

  function testEvent(uint256 num) public {
    emit MyTestEvent(num);
  }
  function testRevert() public {
    revert("testing");
  }

}
