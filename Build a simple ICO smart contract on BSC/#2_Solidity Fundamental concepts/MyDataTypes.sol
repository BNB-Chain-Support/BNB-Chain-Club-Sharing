pragma solidity ^0.5.0;

contract Mydatatypes {
	string public constant value = "myValue";
	bool public myBool = true;
	int public myInt = -1;

// No max value 
	uint public myUint = 1000000000;

// Max is 255
	uint8 public myUint8 = 8; 

// Mas is 10exp77
	uint256 public myUint256 = 105000;  
}