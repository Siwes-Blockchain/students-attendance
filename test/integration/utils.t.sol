// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import {Test} from "forge-std/Test.sol";

contract Utils is Test {
    function test_HashPairShouldNeverRevert() external {
        // it should never revert.
        vm.skip(true);
    }

    function test_HashPairWhenFirstArgIsSmallerThanSecondArg() external {
        // it should match the result of `keccak256(abi.encodePacked(a,b))`.
        vm.skip(true);
    }

    function test_HashPairWhenFirstArgIsBiggerThanSecondArg() external {
        // it should match the result of `keccak256(abi.encodePacked(b,a))`.
        vm.skip(true);
    }

    function test_MinShouldNeverRevert() external {
        // it should never revert.
        vm.skip(true);
    }

    function test_MinWhenFirstArgIsSmallerThanSecondArg() external {
        // it should match the value of `a`.
        vm.skip(true);
    }

    function test_MinWhenFirstArgIsBiggerThanSecondArg() external {
        // it should match the value of `b`.
        vm.skip(true);
    }

    function test_MaxShouldNeverRevert() external {
        // it should never revert.
        vm.skip(true);
    }

    function test_MaxWhenFirstArgIsSmallerThanSecondArg() external {
        // it should match the value of `b`.
        vm.skip(true);
    }

    function test_MaxWhenFirstArgIsBiggerThanSecondArg() external {
        // it should match the value of `a`.
        vm.skip(true);
    }
}
