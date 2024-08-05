// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Owned} from "./Owned.sol";

error Unauthorized();
error InvalidId();
error AlreadyRegistered(uint256 studentId);
error NotRegistered(uint256 studentId);


// struct to hold the `student` type
struct Student {
    uint256 age;
    uint256 attendanceCount;
    bytes32 name;
    bool isRegistered;
    address studentAddress;
}

contract Attendance is Owned {
    // mapping of `Id` to `student`
    mapping(uint256 => Student) StudentsList;

    // track of students Id
    uint256 public studentCount;

    // track `course` to `Id` to `students`
    mapping(bytes32 => mapping(uint256 => Student)) courseToStudents;

    // track authorized accounts by course
    mapping(bytes32 => mapping(address => bool)) public authorizedCourseReps;

    // student creation event
    event studentCreation(
        bytes32 indexed name,
        uint256 indexed age,
        address indexed studentAddress
    );

    // student registered to a course event
    event RegisteredStudent(bytes32 course, uint256 studentId);

    // student de-registered from a course event
    event DeregisteredStudent(bytes32 course, uint256 studentId);

    // auth granted for a course event
    event classRepAuthorized(bytes32 course, address courseRep);

    // auth revoke for a course event
    event classRepRevoked(bytes32 course, address courseRep);

    // student attendance incremented for a course event
    event IncrementedAttendance(bytes32 course, uint256 studentId);

    // grant or revoke auth for a course
    function authorizeCourseRep(bytes32 _course, address[] memory _courseRep, bool _isAuthenticated) public onlyOwner {
        for (uint256 i = 0; i < _courseRep.length; i++) {
            address courseRep_ = _courseRep[i];
            authorizedCourseReps[_course][courseRep_] = _isAuthenticated;
            emit classRepAuthorized(_course, courseRep_);
            
        }
    }

    // create a student
    function createStudent(Student memory _students) external onlyOwner {
        Student storage student_ = StudentsList[studentCount++];
        student_.age = _students.age;
        student_.name = _students.name;
        student_.isRegistered = true;
        student_.studentAddress = _students.studentAddress;
        emit studentCreation(student_.name, student_.age, student_.studentAddress);
    }

    // creates students batch
    function createStudents(Student[] memory _students) external onlyOwner {
        uint256 len_ = _students.length;
        for (uint256 i = 0; i < len_ ; i++) {
            Student storage student_ = StudentsList[studentCount++];
            student_.age = _students[i].age;
            student_.name = _students[i].name;
            student_.isRegistered = true;
            student_.studentAddress = _students[i].studentAddress;
            emit studentCreation(student_.name, student_.age, student_.studentAddress);
        }
    }

    // register students to a course
    function registerStudent(bytes32 _course, uint256 _studentId) public {
        _onlyValidId(_studentId);
        if(!_isAuthorized(_course)) revert Unauthorized();
        Student memory student_ = StudentsList[_studentId];
        if(student_.isRegistered) revert AlreadyRegistered(_studentId);
        student_.isRegistered = true;
        courseToStudents[_course][_studentId] = student_;

        emit RegisteredStudent(_course, _studentId);
    }

    // de-register students from a course
    function deregisterStudent(bytes32 _course, uint256 _studentId) public {
        _onlyValidId(_studentId);
        Student memory student_ = StudentsList[_studentId];
        if(!_isAuthorized(_course) || msg.sender != student_.studentAddress) revert Unauthorized();
        if(!student_.isRegistered) revert NotRegistered(_studentId);

        Student storage courseStudent_ = courseToStudents[_course][_studentId];
        courseStudent_.attendanceCount = 0;
        courseStudent_.isRegistered = false;

        emit DeregisteredStudent(_course, _studentId);
    }

    // incrment attendance count for a student
    function incrementAttendance(bytes32 _course, uint256 _studentId) external {
        _onlyValidId(_studentId);
        if(!_isAuthorized(_course)) revert Unauthorized();
        Student storage student_ = courseToStudents[_course][_studentId];
        student_.attendanceCount++;
        emit IncrementedAttendance(_course, _studentId);
    }

    // increment attendance in batch
    function incrementAttendances(bytes32 _course, uint256[] memory _studentIds) external {
        for(uint i = 0; i < _studentIds.length; i++) {
        if(!_isAuthorized(_course)) revert Unauthorized();
            uint256 studentId_ = _studentIds[i];
            _onlyValidId(studentId_);
            Student storage student_ = courseToStudents[_course][studentId_];
            student_.attendanceCount++;
            emit IncrementedAttendance(_course, studentId_);
        }
    }

    // retrieve a student
    function getStudent(uint256 _studentId) external view returns(Student memory student_) {
        _onlyValidId(_studentId);
        student_ = StudentsList[_studentId];
    }

    // retrieve a student
    function getStudentByCourse(bytes32 _course, uint256 _studentId) external view returns(Student memory student_) {
        _onlyValidId(_studentId);
        student_ = courseToStudents[_course][_studentId];
    }

    // `owner` or `classrep` permission check
    function _isAuthorized(bytes32 _course) internal view returns (bool isAuthorized_) {
        isAuthorized_ = msg.sender == owner || authorizedCourseReps[_course][msg.sender];
    }

    function _onlyValidId(uint256 _studentId) internal view {
        if(_studentId >= studentCount) revert InvalidId();
    }
}