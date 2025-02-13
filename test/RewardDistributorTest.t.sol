pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {RewardDistributor} from "../src/RewardDistributor.sol";

contract RewardDistributorTest is Test {
    RewardDistributor rewardDistributor;
    address attacker = makeAddr("attacker");

    function setUp() public {
        rewardDistributor = new RewardDistributor();
        vm.deal(address(1), 5 ether);
        vm.deal(address(2), 5 ether);
        vm.deal(attacker, 5 ether);
    }

    function testClaimRewards() public {
        for (uint256 i = 0; i < 2; i++) {
            vm.prank(address(uint160(i)));
            rewardDistributor.stake(50);
        }
        vm.startPrank(attacker);
        rewardDistributor.stake(5);
        console.log("total stake:", rewardDistributor.totalStake());
        uint256 stake = rewardDistributor.getUserStakes();
        console.log("Attacker's stake:", stake);
        rewardDistributor.claimReward();
        // console.log(rewardAttacker);
        vm.stopPrank();

    }
}