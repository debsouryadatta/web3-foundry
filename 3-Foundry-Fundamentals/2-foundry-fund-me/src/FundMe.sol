// Get funds from users
// Withdraw funds
// Set a minimun funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    mapping(address funder => uint256 amountFunded) private s_addressToAmountFunded;
    address[] private s_funders;

    address private immutable i_owner;
    uint256 public constant MINIMUM_USD = 5e18;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }




    function fund() public payable {
        // Allow users to send money
        // Have a minimum money to be sent
        // 1. How do we send ETH to this contract?
        require(msg.value.getConversionRate(s_priceFeed) > MINIMUM_USD, "Didn't send enough ETH"); // 1 ETH = 10^18 wei
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] = s_addressToAmountFunded[msg.sender] + msg.value;
    }

    function getVersion() public view returns(uint256){
        return s_priceFeed.version();
    }


    function cheaperWithdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length; // creating memory variable for gas optimisation
        for(uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++){
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        // reset the array
        s_funders = new address[](10);
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }



    function withdraw() public onlyOwner {
        for(uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++){
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        // reset the array
        s_funders = new address[](10);

        // 3 ways of transfering

        // 1. transfer
        // payable(msg.sender).transfer(address(this).balance);
        // 2. send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        // 3. call -> optimal approach
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }


    modifier onlyOwner(){
        // require(msg.sender == i_owner, "Sender is not owner!");
        if(msg.sender != i_owner) { revert FundMe__NotOwner(); }
        _;
    }


    // What happens if someone sends this contract ETH without calling the fund function
    
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    // View/Pure functions (Getters)
    function getAddressToAmountFunded(address fundingAddress) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }



}


// What is a revert?
// Undo any actions that have been done and send the remaining gas back
// (Means even though the transaction fails but the gas fees will be applied for the
// lines of code that has been executed. The refund will be provided for the lines
// which are not being executed)


// Chainlink Oracle network -> Helps to connect to the offchain data


// Whenever we want to interact with a contract, we need the address and the ABI
// Contract Interface helps us to get the ABI very easily.
// Interface -> Lines of code which can be called inside the main contract
// Although the interface didn't have any logic still it gave a result,
// because the address we have used here have its own functions which gives the 
// result when called inside the interface AggregatorV3Interface wrapper


// Directly importing AggregatorV3Interface from Github/npm package


// In Solidity Math - Everything should be converted into 1e18 pattern for better
// eth calculations


// msg.value.getConversionRate() -> Using this we can get the library function since
// msg.value is a uint256, where the first parameter of the getConversionRate func.
// is the msg.value, we can also pass other arguments one by one


// SafeMath, Overflow checking, and the "unchecked" keyword(Before version 0.8.0)


// Using "constant" and "immutable" for better gas optimisations


// Custom errors for better gas optimisations