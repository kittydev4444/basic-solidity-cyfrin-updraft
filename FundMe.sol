
// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUsd = 5e18;
    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    function fund() public payable  {
        require(msg.value.getConversionRate() >= minimumUsd, "didn't send enough ETH"); // 1e18 = 1 ETH = 1000000000000000000 = 1 * 10 ** 18
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        // for loop
        // [1, 2, 3, 4] elements
        // 0, 1 , 2, 3 indexes
        // for(/* starting index, ending index, step amount */)
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the array
        funders = new address[](0);
        // withdraw the funds

        // transfer
        // msg.sender = type address
        // payable(msg.sender) = type payable address
        // automatic revert if tsx falild
        // payable(msg.sender).transfer(address(this).balance);
        // send
        // revert only when using require
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        // call
       (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
       require(callSuccess, "Call failed");
    }

    modifier onlyOwner() {
                require(msg.sender == owner, "Must be owner!");
                _;
    }
}