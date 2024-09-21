// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import {Test} from "forge-std/Test.sol";

contract Attendance is Test {
    function test_IncrementAttendanceWhenCallerIsNotAuthorized() external {
        // it reverts with the error {Unauthorized}.
        vm.skip(true);
    }

    function test_IncrementAttendanceWhenStudentIdIsInvalid() external {
        // it reverts with the error {InvalidId}.
        vm.skip(true);
    }

    function test_IncrementAttendanceWhenCallerAndStudentIdAreValid() external {
        // it should increment the student attendance in the {courseToStudents} mapping.
        // it should emit a {IncrementedAttendance} event.
        vm.skip(true);
    }

    function test_IncrementAttendancesWhenCallerIsNotAuthorized() external {
        // it reverts with the error {Unauthorized}.
        vm.skip(true);
    }

    function test_IncrementAttendancesWhenStudentIdIsInvalid() external {
        // it reverts with the error {InvalidId}.
        vm.skip(true);
    }

    function test_IncrementAttendancesWhenCallerAndAllStudentIdsAreValid() external {
        // it should increment the student attendance in the {courseToStudents} mapping.
        // it should emit a {IncrementedAttendance} event for each student.
        vm.skip(true);
    }
}
