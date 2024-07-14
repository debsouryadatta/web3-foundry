// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

import { AggregatorV3Interface } from "./AggregatorV3Interface.sol";

library PriceConverter {

    // To get the price of 1ETH
    function getPrice() public view returns(uint256) {
        // Address required
        // ABI required
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,) = priceFeed.latestRoundData();
        // Price of ETH in terms of USD
        // 2000.00000000
        return uint256(price * 1e10);
    }




    // To get the usd amount from eth amount
    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        // 1 ETH?
        // 2000_00000000
        uint256 ethPrice = getPrice();
        // (2000_000000000000000000 * 1_000000000000000000) / 1e18;
        // $2000 = 1 ETH
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion() public view returns(uint256){
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}