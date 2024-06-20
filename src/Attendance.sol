// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

error InvalidStudentId();

contract Attendance {
    // struct to hold the `student` type
    struct Student {
        uint256 age;
        uint256 attendanceCount;
        string name;
    }

    // mapping of `Id` to `student`
    mapping(uint256 => Student) StudentsList;

    // state to keep track of students Id
    uint256 public studentCount;

    function createStudent(uint256 _age, string memory _name) external {
        Student storage student = StudentsList[studentCount++];
        student.age = _age;
        student.attendanceCount = 0;
        student.name = _name;
    }

    function incrementAttendance(uint256 _studentId) external {
        if(_studentId >= studentCount) revert InvalidStudentId();
        Student storage student = StudentsList[_studentId];
        student.attendanceCount++;
    }

    function getStudent(uint256 _studentId) external view returns(Student memory) {
        if(_studentId >= studentCount) revert InvalidStudentId();
        Student memory student = StudentsList[_studentId];
        return student;
    }
}