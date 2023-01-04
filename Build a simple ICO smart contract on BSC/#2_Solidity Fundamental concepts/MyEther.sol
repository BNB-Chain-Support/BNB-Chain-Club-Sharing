pragma solidity 0.5.1;

contract MyEther {
	address payable wallet;
	mapping(address => uint256) public sender;

	constructor(address payable _wallet) public {
	    wallet = _wallet;
	}

	function sendEther() public payable {
		//send ether to the wallet
	    sender[msg.sender]+=1;
	    wallet.transfer(msg.value);
	}
}