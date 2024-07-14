// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol"; // To understand that this is a Forge script for deploy
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    function run() external returns (SimpleStorage) {
        // Broadcast means to deploy the contract to the blockchain, the code inside the broadcast will be executed on the blockchain
        vm.startBroadcast(); // vm is a cheat code which only works in Foundry
        SimpleStorage simpleStorage = new SimpleStorage();
        vm.stopBroadcast();
        return simpleStorage;
    }
}
