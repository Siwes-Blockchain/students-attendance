// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import {Test} from "forge-std/Test.sol";

contract allowToAuthtree is Test {
    function test_RevertWhen_CallerIsNotOwner() external {
        // it should revert.
        vm.skip(true);
    }

    modifier whenCallerIsOwner() {
        _;
    }

    function test_GivenTheCourseAddressesAndIsAuthenticatedIsSet() external whenCallerIsOwner {
        // it should set the auth for the addresses in the `authorizedCourseReps` mapping.
        vm.skip(true);
    }

    function test_GivenTheCourseAddressesAndIsAuthenticatedIsUnset() external whenCallerIsOwner {
        // it should unset the auth for the addresses in the `authorizedCourseReps` mapping.
        vm.skip(true);
    }
}
