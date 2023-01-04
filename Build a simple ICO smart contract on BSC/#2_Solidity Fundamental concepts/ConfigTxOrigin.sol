pragma solidity ^0.5.0;

// Tx.origin is not the same as Msg.Sender

// Tx.origin = original external account that started the transaction. 
// The owner can never be a contract but a user account.

// Msg.sender = immediate account that invokes the function. This can be a contract.

// Example. A --> B --> C --> D --> E
// In this call chain, inside contract D, msg.sender will be C, and tx.origin will be A.


contract C {
    function sendAddress() public view returns(address){
        return tx.origin;
    }
}

contract B {
    function callContractC() public returns(address){
        C _c = new C();
        return _c.sendAddress();
    }
}


contract A {
    function callContractB() public returns(address){
        B _b = new B();
        return _b.callContractC();
    }
}