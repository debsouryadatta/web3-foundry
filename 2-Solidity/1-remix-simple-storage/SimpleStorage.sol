// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18; // solidity versions

contract SimpleStorage{
    uint256 myFavoriteNumber; //0

    struct Person{
        uint256 favoriteNumber;
        string name;

    }

    Person[] public listOfPeople;

    mapping(string => uint256) public nameToFavoriteNumber;


    function store(uint256 _favoriteNumber) public virtual {
        myFavoriteNumber = _favoriteNumber;
    }

    function retrive() public view returns (uint256){
        return myFavoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        Person memory newPerson = Person(_favoriteNumber, _name);
        listOfPeople.push(newPerson);
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}

// Public, Private, External, Internal (By default the variables are internal)
// Modifiers
// view and pure functions doesn't cost gas fees
// view - These functions can only return values or variables(can not perform and logics)
// pure - These functions can only return value, they can't even return variables


// memory, calldata, storage
// memory -> temporary variable which can be changed
// calldata -> temporary variable which can not be changed
// storage -> permanent variable which can be changed
// We need to give memory in front of array, struct, mapping
// Inside functions, they are temporary variables(memory)
// Outside functions, by default they are permanent variables(storage)