// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LoyaltyApp is Ownable {
    ERC20 public loyaltyToken;
    mapping(address => uint256) public loyaltyPoints;

    event LoyaltyPointsEarned(address indexed user, uint256 points);
    event LoyaltyPointsRedeemed(address indexed user, uint256 points);

    constructor(address tokenAddress) {
        loyaltyToken = ERC20(tokenAddress);
    }

    // Function to allow users to earn loyalty points
    function earnLoyaltyPoints(uint256 points) external {
        loyaltyPoints[msg.sender] += points;
        emit LoyaltyPointsEarned(msg.sender, points);
    }

    // Function to allow users to redeem loyalty points
    function redeemLoyaltyPoints(uint256 points) external {
        require(loyaltyPoints[msg.sender] >= points, "Insufficient loyalty points");
        
        loyaltyPoints[msg.sender] -= points;
        emit LoyaltyPointsRedeemed(msg.sender, points);
    }

    // Function to check the loyalty points balance of a user
    function checkLoyaltyPoints(address user) view external returns (uint256) {
        return loyaltyPoints[user];
    }

    // Function to withdraw any ERC20 tokens sent to the contract
    function withdrawTokens(address tokenAddress, address to, uint256 amount) onlyOwner external {
        ERC20(tokenAddress).transfer(to, amount);
    }
}