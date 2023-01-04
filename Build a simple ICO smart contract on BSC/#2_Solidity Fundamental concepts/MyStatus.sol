pragma solidity ^0.5.0;

contract Mystatus {
	enum Status {Red, Amber, Green}
	Status public statusVal;

	constructor() public{
	    statusVal=Status.Green;
	}
	
	function green() public  {
	    statusVal=Status.Green;
	}
	function amber() public {
	    statusVal = Status.Amber;
	}
	
    function red() public  {
	    statusVal=Status.Red;
	}
}