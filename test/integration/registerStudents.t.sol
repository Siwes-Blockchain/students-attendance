// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import {Test} from "forge-std/Test.sol";

contract RegisterStudents is Test {
    function test_RegisterStudentsWhenCallerIsNotAuthorized() external {
        // it reverts with the error {Unauthorized}.
        vm.skip(true);
    }

    function test_RegisterStudentsWhenStudentIdIsInvalid() external {
        // it reverts with the error {InvalidId}.
        vm.skip(true);
    }

    function test_RegisterStudentsWhenStudentIsAlreadyRegistered() external {
        // it reverts with the error {AlreadyRegistered}.
        vm.skip(true);
    }

    function test_RegisterStudentsRevertWhen_CourseProvidedIsInvalid() external {
        // it should revert.
        vm.skip(true);
    }

    modifier whenCallerIsAuthorizedForCourse() {
        _;
    }

    function test_RegisterStudentsWhenCourseAndStudentIdAreValid() external whenCallerIsAuthorizedForCourse {
        // it should register the student to {courseToStudents} mapping
        vm.skip(true);
    }

    function test_DeregisterStudentsWhenCallerIsNotAuthorizedOrNotTheStudent() external {
        // it reverts with the error {Unauthorized}.
        vm.skip(true);
    }

    function test_DeregisterStudentsWhenStudentIdIsInvalid() external {
        // it reverts with the error {InvalidId}.
        vm.skip(true);
    }

    function test_DeregisterStudentsWhenStudentIsNotRegisteredForCourse() external {
        // it reverts with the error {NotRegistered}.
        vm.skip(true);
    }

    modifier whenCalledByAnAuthorizedAccount() {
        _;
    }

    function test_DeregisterStudentsGivenThatStudentIsRegisteredForCourse() external whenCalledByAnAuthorizedAccount {
        // it deregisters the student from the {courseToStudents} mapping
        // it emits a {DeregisteredStudent} event.
        vm.skip(true);
    }

    modifier whenCalledByTheStudent() {
        _;
    }

    function test_DeregisterStudentsGivenThatTheStudentIsRegisteredForCourse() external whenCalledByTheStudent {
        // it deregisters the student from the {courseToStudents} mapping
        // it emits a {DeregisteredStudent} event.
        vm.skip(true);
    }
}
