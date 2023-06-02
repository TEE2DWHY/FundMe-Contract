// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./PriceConverter.sol";

contract FundMe{
    using PriceConverter for uint256;
    uint256 public maxUsd = 1000 * 1e18; // we use the Wei format because our getConversionRate function returns amount in USD in Wei format.
    address[] public funders; // created an array of people who calls the fund function
    mapping(address => uint256) public addressToAmountFunded; // mapped each address to the amount they've funded
    address public owner; // owner of contract
    constructor(){
        owner = msg.sender;
    }
   // funding
    function fund() public payable {
        require((msg.value.getConversionRate()) <= maxUsd, "ETH funding amount exceeded");
        funders.push(msg.sender); // push addresses to the funders array
        addressToAmountFunded[msg.sender] = msg.value; // map address to amount sent
    }
    //withdraw
    function withdraw() public onlyOwner{
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++ ){
            address funder = funders[funderIndex]; // we get the funder address from the first index
            addressToAmountFunded[funder] = 0; // we reset the amount funded by funder to 0
        }
        funders = new address[](0); // we refresh the funders array after withdrawal
        // payable(msg.sender).transfer(address(this).balance);=> // this is withdrawal method using the transfer method
        // bool sendSuccess = payable(msg.sender).send(address(this).balance); => // this is withdrawal method using send method
        // require(sendSuccess, "Send Failure");
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}(""); // this is withdrawal method using the call method
        require(callSuccess, "Call Failure");
    }

    // to ensure only the contract creator can call the withdraw function we do:
    modifier onlyOwner{
        msg.sender == owner;
        _;
    }
}
