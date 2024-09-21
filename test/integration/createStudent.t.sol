// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import {Test} from "forge-std/Test.sol";

contract createStudenttree is Test {
    function test_RevertWhen_CallerIsNotOwner() external {
        // it should revert
        vm.skip(true);
    }

    modifier whenCallerIsOwner() {
        _;
    }

    function test_WhenTheStudentStructIsProvided() external whenCallerIsOwner {
        // it should add the student to the {StudentsList} mapping.
        // it should emit a {studentCreation} event.
        vm.skip(true);
    }

    function test_GivenTheStudentStructListIsProvided() external whenCallerIsOwner {
        // it should add each students to the {StudentsList} mapping.
        // it should emit a {studentCreation} event.
        vm.skip(true);
    }
}
