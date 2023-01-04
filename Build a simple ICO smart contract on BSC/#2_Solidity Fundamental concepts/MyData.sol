pragma solidity ^0.5.0;

contract Mydata {
    Person[] public people;

    uint256 public peopleCount;

    struct Person {
        string _firstName;
        string _lastName;
    }

    function add(string memory _firstName, string memory _lastName) public {
        peopleCount = people.push(Person(_firstName, _lastName));
    }
}