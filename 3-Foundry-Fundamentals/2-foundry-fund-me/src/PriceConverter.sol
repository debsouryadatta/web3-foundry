// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {

    // To get the price of 1ETH
    function getPrice(AggregatorV3Interface priceFeed) public view returns(uint256) {
        // Address required
        // ABI required
        (,int256 price,,,) = priceFeed.latestRoundData();
        // Price of ETH in terms of USD
        // 2000.00000000
        return uint256(price * 1e10);
    }




    // To get the usd amount from eth amount
    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) public view returns(uint256) {
        // 1 ETH?
        // 2000_00000000
        uint256 ethPrice = getPrice(priceFeed);
        // (2000_000000000000000000 * 1_000000000000000000) / 1e18;
        // $2000 = 1 ETH
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion(AggregatorV3Interface priceFeed) public view returns(uint256){
        return priceFeed.version();
    }
}