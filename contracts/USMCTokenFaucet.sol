// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ERC-20 Token Interface
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

// The Token Exchange Contract
contract TokenExchange {

    IERC20 public token; // ERC-20 token contract
    address public owner;
    
    // Exchange rate: How many tokens you get for 1 ETH
    uint256 public rate;

    // Events
    event TokensPurchased(address indexed buyer, uint256 ethAmount, uint256 tokenAmount);

    // Constructor to set the token address and initial rate
    constructor(address _tokenAddress, uint256 _rate) {
        token = IERC20(_tokenAddress);
        rate = _rate;
        owner = msg.sender;
    }

    // Function to receive ETH and send tokens
    receive() external payable {
        uint256 tokenAmount = msg.value * rate;
        require(token.balanceOf(address(this)) >= tokenAmount, "Not enough tokens in the contract");

        // Transfer tokens to the sender
        token.transfer(msg.sender, tokenAmount);

        // Emit event
        emit TokensPurchased(msg.sender, msg.value, tokenAmount);
    }

    // Function to withdraw ETH from the contract (only owner)
    function withdrawETH(uint256 amount) external {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(amount);
    }

    // Function to withdraw tokens from the contract (only owner)
    function withdrawTokens(uint256 amount) external {
        require(msg.sender == owner, "Only owner can withdraw");
        token.transfer(owner, amount);
    }

    // Function to set a new rate (only owner)
    function setRate(uint256 newRate) external {
        require(msg.sender == owner, "Only owner can set the rate");
        rate = newRate;
    }

    // Function to get the contract's ETH balance
    function getEthBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Function to get the contract's token balance
    function getTokenBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }
}
