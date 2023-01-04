// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract Calc {
    uint256 public value;
    
    function add(uint _value1, uint _value2) public {
        value = SafeMath.add(_value1, _value2);
    }
}