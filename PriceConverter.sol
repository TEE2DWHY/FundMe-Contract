// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"; // imported the Chain link aggreagtor

library PriceConverter {
    // We firstly want to get the current price of ETH
    function getPrice() public view returns (uint256) {
        //since we in our get price function we are interacting with a contract outside our project we need 2 params (ABI & address of the contract)
        //ABI (We access this by importing the Chain link aggreagtor)
        //Address : 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419 - Contract Address for price feed of ETH/USD
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    // We want to get the price in USD for an amount of ETH
    function getConversionRate(
        uint256 ethAmount
    ) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 amountInUsd = (ethPrice * ethAmount) / 1e18;
        return amountInUsd;
    }
}
