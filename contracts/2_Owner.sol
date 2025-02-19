// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Minimal ERC-20 Interface
interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract USMCTokenLock {
    address public owner;
    IERC20 public token;
    uint256 public lockUntil;

    // Correctly define the token address (address type, not string)
    address public USMCToken = 0x3f28E01E9BF7a2FC08a0eF80c6A480f69AE5e1B5;

    // Constructor sets the token address and sets the lock period to 0
    constructor() {
        owner = msg.sender;
        token = IERC20(USMCToken); // Initialize token interface with the correct address
    }

    // Withdraw tokens after the lock period ends
    function withdrawTokens(uint256 amount) external {
        require(block.timestamp >= lockUntil, "Tokens are still locked");
        require(token.transfer(msg.sender, amount), "Token transfer failed");
    }

    // Lock tokens for a specific time period
    function lockTokens(uint256 _addlockuntilblock) external {
        require(block.timestamp >= lockUntil, "Tokens are still locked");
        lockUntil = _addlockuntilblock;
    }

    // Function to check the token balance of the contract
    function getTokenBalance() external view returns (uint256) {
        return token.balanceOf(address(this));  // Returns the token balance of the contract
    }

    // Function to get the current block number
    function CurrentBlockNumber() external view returns (uint256) {
        return block.number;  // Returns the current block number
    }

    // Reject any incoming Ether transfer
    receive() external payable {
        revert("Ether transfers are not accepted");
    }

    // Fallback function to reject any call with data
    fallback() external payable {
        revert("Ether transfers with data are not accepted");
    }
}
