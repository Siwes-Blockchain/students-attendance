// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Attendance, Student} from "../src/Attendance.sol";

contract AttendanceTest is Test {
    Attendance public attendance;
    address lecturer = address(0xdeadbeef);

    // initialize test courses.
    bytes32 CSC201 = keccak256("csc201");
    bytes32 CSC202 = keccak256("csc202");
    bytes32 CSS301 = keccak256("csc301");

    // make addresses for course reps
    address rep0 = vm.addr(100);
    address rep1 = vm.addr(101);
    address rep2 = vm.addr(102);

    // make names for students
    string student0Name = "Jon Doe";
    string student1Name = "Jon Foe";
    string student2Name = "Jon Roe";

    // make addresses for test students
    address student0Addr = makeAddr("student0Name");
    address student1Addr = makeAddr("student1Name");
    address student2Addr = makeAddr("student2Name");

    // make an unauthorized address.
    address unauthorizedAcct = vm.addr(uint256(bytes32("unauthorized")));

    function setUp() public {
        // set up Attendance contract with `lecturer` as owner
        vm.prank(lecturer);
        attendance = new Attendance();
    }

    // test owner is set correctly
    function test_OwnerIsSetCorrectly() public view {
        assertEq(attendance.owner(), lecturer);
    }

    // test contract owner can grant auth for courses
    function test_OwnerCanAuthorizeForCourse() public {
        vm.startPrank(lecturer);

        address[] memory courseReps_ = new address[](3);
        courseReps_[0] = rep0;
        courseReps_[1] = rep1;
        courseReps_[2] = rep2;

        attendance.authorizeCourseRep(CSC201, courseReps_, true);

        bool rep0Authorized = attendance.authorizedCourseReps(CSC201, rep0);
        bool rep1Authorized = attendance.authorizedCourseReps(CSC201, rep1);
        bool rep2Authorized = attendance.authorizedCourseReps(CSC201, rep2);

        bool unauthorized = attendance.authorizedCourseReps(CSC201, unauthorizedAcct);

        vm.stopPrank();
        assert(rep0Authorized);
        assert(rep1Authorized);
        assert(rep2Authorized);
        assertFalse(unauthorized);
    }

    // test contract owner can create student
    function test_OwnerCanCreateStudent() public {
        uint256 age_ = 18;

        Student memory student_ = Student({
            age: age_,
            attendanceCount: 0,
            name: student0Name,
            isRegistered: false,
            studentAddress: student0Addr
        });

        vm.prank(lecturer);
        attendance.createStudent(student_);

        uint256 studentCount_ = attendance.studentCount();

        assertEq(studentCount_, 1);
        assertEq(student_.age, age_);
        assertEq(student_.name, student0Name);
        assertEq(student_.attendanceCount, 0);
        assertEq(student_.studentAddress, student0Addr);
    }

    // test contract owner can create students
    function test_OwnerCanCreateStudents() public {
        Student memory student0_ = Student({
            age: 18,
            attendanceCount: 0,
            name: student0Name,
            isRegistered: false,
            studentAddress: student0Addr
        });

        Student memory student1_ = Student({
            age: 19,
            attendanceCount: 0,
            name: student1Name,
            isRegistered: false,
            studentAddress: student1Addr
        });

        Student memory student2_ = Student({
            age: 20,
            attendanceCount: 0,
            name: student2Name,
            isRegistered: false,
            studentAddress: student2Addr
        });

        Student[] memory students_ = new Student[](3);
        students_[0] = student0_;
        students_[1] = student1_;
        students_[2] = student2_;

        vm.prank(lecturer);
        attendance.createStudents(students_);

        uint256 studentCount_ = attendance.studentCount();

        assertEq(studentCount_, 3);
        assertEq(attendance.getStudent(0).studentAddress, student0_.studentAddress);
        assertEq(attendance.getStudent(1).studentAddress, student1_.studentAddress);
        assertEq(attendance.getStudent(2).studentAddress, student2_.studentAddress);
    }

    // test non-contract owner cannot create student
    function testFail_NonOwnerCannotCreateStudent() public {
        Student memory student_ = Student({
            age: 18,
            attendanceCount: 0,
            name: student0Name,
            isRegistered: false,
            studentAddress: student0Addr
        });

        // Attempt to create a student using an unauthorized account
        vm.prank(unauthorizedAcct);
        attendance.createStudent(student_);

        uint256 studentCount_ = attendance.studentCount();

        // Asserting that the student count remains zero
        assertEq(studentCount_, 0);
    }

    // test owner can register a student for a course
    function test_OwnerCanRegisterStudentForCourse() public {
        vm.startPrank(lecturer);

        uint256 age_ = 18;
        Student memory student_ = Student({
            age: age_,
            attendanceCount: 0,
            name: student0Name,
            isRegistered: false,
            studentAddress: student0Addr
        });

        attendance.createStudent(student_);

        // Register a student for CSC201
        attendance.registerStudent(CSC201, 0);

        // Verify that the student is registered
        assertTrue(attendance.getStudentByCourse(CSC201, 0).isRegistered);
    }

    function testFail_DoubleRegistrationFails() public {
        vm.startPrank(lecturer);

        uint256 age_ = 18;
        Student memory student_ = Student({
            age: age_,
            attendanceCount: 0,
            name: student0Name,
            isRegistered: false,
            studentAddress: student0Addr
        });

        attendance.createStudent(student_);

        // Register a student for CSC201
        attendance.registerStudent(CSC201, 0);

        // should throw an error {AlreadyRegistered}
        attendance.registerStudent(CSC201, 0);
    }

    // test a course rep can register a student for a course
    function test_CourseRepCanRegisterStudentForCourse() public {
        // Authorize a course rep first
        vm.startPrank(lecturer);
        address[] memory courseReps_ = new address[](1);
        courseReps_[0] = rep0;
        attendance.authorizeCourseRep(CSC201, courseReps_, true);

        // create a student
        uint256 age_ = 18;
        Student memory student_ = Student({
            age: age_,
            attendanceCount: 0,
            name: student0Name,
            isRegistered: false,
            studentAddress: student0Addr
        });
        attendance.createStudent(student_);
        vm.stopPrank();

        // Now, the course rep can register a student
        vm.prank(rep0);
        attendance.registerStudent(CSC201, 0);

        // Verify that the student is registered
        assertTrue(attendance.getStudentByCourse(CSC201, 0).isRegistered);
    }

    // test a student can de-register themselves from a course
    function test_StudentCanDeRegisterThemself() public {
        vm.startPrank(lecturer);

        uint256 age_ = 18;
        Student memory student_ = Student({
            age: age_,
            attendanceCount: 0,
            name: student0Name,
            isRegistered: false,
            studentAddress: student0Addr
        });

        attendance.createStudent(student_);

        // Register a student for CSC201
        attendance.registerStudent(CSC201, 0);
        vm.stopPrank();

        // Now, the student de-registers themselves
        vm.prank(student0Addr);
        attendance.deregisterStudent(CSC201, 0);

        // Verify that the student is no longer registered
        assertFalse(attendance.getStudentByCourse(CSC201, 0).isRegistered);
    }

    // test authorized reps can increment attendance score
    function test_CourseRepsCanIncrmentAttendance() public {
        // Authorize a course rep first
        vm.startPrank(lecturer);
        address[] memory courseReps_ = new address[](1);
        courseReps_[0] = rep0;
        attendance.authorizeCourseRep(CSC201, courseReps_, true);

        // Register a student first
        uint256 age_ = 18;
        Student memory student_ = Student({
            age: age_,
            attendanceCount: 0,
            name: student0Name,
            isRegistered: false,
            studentAddress: student0Addr
        });

        attendance.createStudent(student_);

        // Register a student for CSC201
        attendance.registerStudent(CSC201, 0);
        vm.stopPrank();  

        // Now, the course rep increments attendance
        vm.prank(rep0);
        attendance.incrementAttendance(CSC201, 0);

        // Verify that the student's attendance count has increased
        Student memory studentOfCSC201 = attendance.getStudentByCourse(CSC201, 0);
        assertEq(studentOfCSC201.attendanceCount, 1);
    }

    // // test an unauthorized rep cannot increment attendance score
    function testFail_UnauthorizedAcctsCannotIncrementAttendance() public {
        // Register a student first
        vm.startPrank(lecturer);

        uint256 age_ = 18;
        Student memory student_ = Student({
            age: age_,
            attendanceCount: 0,
            name: student0Name,
            isRegistered: false,
            studentAddress: student0Addr
        });

        attendance.createStudent(student_);

        attendance.registerStudent(CSC201, 0);
        vm.stopPrank();

        // Attempt to increment attendance using an unauthorized account
        vm.prank(unauthorizedAcct);
        attendance.incrementAttendance(CSC201, 0);
    }
}
