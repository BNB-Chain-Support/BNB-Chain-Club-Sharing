pragma solidity ^0.5.0;

contract Counter {
 
    uint count = 0;
    address owner; //Let's keep track of the owner
 
    constructor() public{
        owner = msg.sender; // We keep the address of the creator
    } 
 
    function increment() public {
       if (owner == msg.sender) { // We check who calls the function
          count = count + 1;
       }
    }
 
    /* used to read the value of count */
    function getCount() public view returns (uint) {
       return count;
    }
}