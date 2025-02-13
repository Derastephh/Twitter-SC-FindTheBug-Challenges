// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";

/*A DeFi platform is designed to distribute rewards to users based on their proportion of the total stake in the system. The smart contract provided below is supposed to calculate and distribute the rewards. Is there an issue with the way the calculation is performed?
*/

contract RewardDistributor is Test {
    uint256 public totalStake;
    uint256 public totalReward;
    mapping(address => uint256) public stakes;
    address public owner;

    error NotOwner();

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotOwner();
        }
        _;
    }

    // Owner sets the total reward to distribute
    function setTotalReward(uint256 _totalReward) external onlyOwner {
        totalReward = _totalReward;
    }

    // Stake some amount
    function stake(uint256 _amount) external {
        stakes[msg.sender] += _amount;
        totalStake += _amount;
    }

    // Calculate and retrieve the reward for the caller based on their stake
    function claimReward() external {
        uint256 userStake = stakes[msg.sender];
        uint256 reward = (userStake * totalReward) / totalStake;
        console.log("reward after attacker calls claimReward function:", reward);
        payable(msg.sender).transfer(reward);
    }

    // Function to receive Ether, the native cryptocurrency used for rewards
    receive() external payable {}

    // Function to withdraw funds sent to the contract by mistake
    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function getUserStakes() public view returns (uint256) {
        uint256 stakesUser = stakes[msg.sender];
        return stakesUser;
    }
}
