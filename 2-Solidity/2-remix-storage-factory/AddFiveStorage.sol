// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19; // solidity versions

import { SimpleStorage } from "./SimpleStorage.sol";

contract AddFiveStorage is SimpleStorage {
    function store(uint256 _newNumber) public override {
        myFavoriteNumber = _newNumber + 5;
    }
}

// We can override functions in parent contract from children contract
// -> 1. We need to put "virtual" keyword inside the function which can be override
// -> 2. We need to put "override" keyword inside the function which should override