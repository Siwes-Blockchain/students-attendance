// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Attendance, Student} from "../src/Attendance.sol";

contract AttendanceTest is Test {
    Attendance public attendance;
    address lecturer = address(0xdeadbeef);

    // make addresses for reps.
    address rep1 = vm.addr(100);
    address rep2 = vm.addr(101);
    address rep3 = vm.addr(102);

    // make an unauthorized address.
    address unauthorizedAcct = vm.addr(uint256(bytes32("unauthorized")));


    function setUp() public {
        // set up Attendance contract with `lecturer` as owner
        vm.prank(lecturer);
        attendance = new Attendance();
    }

    function test_OwnerIsSetCorrectly() public view {
        assertEq(attendance.owner(), lecturer);
    }

    function test_OwnerCanAuthorize() public {
        vm.startPrank(lecturer);
        _grantAuth();
        bool rep1Authorized = attendance.isAuthorized(rep1);
        bool rep2Authorized = attendance.isAuthorized(rep2);
        bool rep3Authorized = attendance.isAuthorized(rep3);
        bool unauthorized = attendance.isAuthorized(unauthorizedAcct);
        vm.stopPrank();
        assert(rep1Authorized);
        assert(rep2Authorized);
        assert(rep3Authorized);
        assertEq(unauthorized, false);
        assertFalse(unauthorized);
    }

    function test_OwnerCanAddAStudent() public {
        uint256 age_ = 18;
        bytes32 name_ = keccak256(bytes("Adan Joe"));

        vm.prank(lecturer);
        attendance.createStudent(age_, name_);

        uint256 studentCount_ = attendance.studentCount();
        Student memory student_ = attendance.getStudent(0);

        assertEq(studentCount_, 1);
        assertEq(student_.age, age_);
        assertEq(student_.name, name_);
        assertEq(student_.attendanceCount, 0);
    }

    function test_OwnerCanAddStudents() public view {
        uint256[] memory ages_ = new uint256[](3);
        bytes32[] memory names_ = new bytes32[](3);

        // createStudents(uint256[] memory _ages, bytes32[] memory _names)
        assert(true);
    }

    function testFail_NonOwnerCannotAddStudent() public {
        uint256 age_ = 18;
        bytes32 name_ = keccak256(bytes("Jon Smith"));

        attendance.createStudent(age_, name_);
    }

    function test_AuthorizedAcctsCanIncrmentAttendance() public {
        uint256 age_ = 18;
        bytes32 name_ = keccak256(bytes("Jon Joe"));

        vm.startPrank(lecturer);
        _grantAuth();
        attendance.createStudent(age_, name_);
        vm.stopPrank();

        vm.prank(rep1);
        attendance.incrementAttendance(0);

        Student memory student_ = attendance.getStudent(0);
        assertEq(student_.attendanceCount, 1);
    }

    function test_AuthorizedAcctsCanIncrmentAttendances() public view {
        uint[] memory studentIds_ = new uint256[](0);

        assert(true);
    }

    function testFail_UnauthorizedAcctsCannotIncrementAttendance() public {
        uint256 age_ = 18;
        bytes32 name_ = keccak256(bytes("Alan Tim"));

        vm.prank(lecturer);
        attendance.createStudent(age_, name_);

        vm.prank(unauthorizedAcct);
        attendance.incrementAttendance(0);
    }

    // Internal functions
    function _grantAuth() internal {
        attendance.authorizeClassRep(rep1);
        attendance.authorizeClassRep(rep2);
        attendance.authorizeClassRep(rep3);
    }
    
}
