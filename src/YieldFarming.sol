// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import {Test, console} from "forge-std/Test.sol";

contract YieldFarming {
    struct Stake {
        uint256 amount;
        uint256 depositTime;
        bool withdrawn;
    }

    mapping(address => Stake) public stakes;
    uint256 public rewardRate = 10; // 10% yield per day
    uint256 public totalRewards;

    function stake() external payable {
        require(msg.value > 0, "Must stake ETH");
        require(stakes[msg.sender].amount == 0, "Already staked");

        stakes[msg.sender] = Stake({
            amount: msg.value,
            depositTime: block.timestamp,
            withdrawn: false
        });

        console.log("Deposit Time:", block.timestamp);
    }

    function withdraw() external {
        Stake storage userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No stake found");
        require(!userStake.withdrawn, "Already withdrawn");
        console.log("Staked Amount:", userStake.amount);

        uint256 timeStaked = block.timestamp - userStake.depositTime;
        console.log("Time Staked:", timeStaked);
        uint256 rewards = (userStake.amount * rewardRate * timeStaked) /
            (1 days * 100);
        console.log("Rewards:", rewards);

        uint256 totalAmount = userStake.amount + rewards;
        require(
            address(this).balance >= totalAmount,
            "Not enough ETH in contract"
        );

        console.log("Contract Balance Before Transfer:", address(this).balance);
        console.log("Total Amount to Transfer:", totalAmount);

        console.log("Withdrawn Status before setting:", userStake.withdrawn);
        userStake.withdrawn = true;
        totalRewards = totalAmount;
        console.log("Withdrawn Status after setting:", userStake.withdrawn);
        (bool success, ) = payable(msg.sender).call{value: totalAmount}("");
        require(success, "ETH transfer failed");
    }
}

contract AttackYield {
    YieldFarming yieldFarming;
    address owner;

    constructor(address _yieldFarming) {
        yieldFarming = YieldFarming(_yieldFarming);
        owner = msg.sender;
    }

    function attack() public payable {
        require(msg.value > 0, "must deposit eth");

        yieldFarming.stake{value: msg.value}();
    }

    function attackAgain() public {
        yieldFarming.withdraw();
    }

    function collect() public {
        (bool success, ) = payable(msg.sender).call{
            value: yieldFarming.totalRewards()
        }("");
        require(success, "ETH transfer failed");
    }

    receive() external payable {}
}
