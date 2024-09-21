// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

interface Attendance {
    struct Student {
        uint256 age;
        uint256 attendanceCount;
        bytes32 name;
        bool isRegistered;
        address studentAddress;
    }

    error AlreadyRegistered(uint256 studentId);
    error InvalidId();
    error NotOwner();
    error NotRegistered(uint256 studentId);
    error Unauthorized();

    event DeregisteredStudent(bytes32 course, uint256 studentId);
    event IncrementedAttendance(bytes32 course, uint256 studentId);
    event RegisteredStudent(bytes32 course, uint256 studentId);
    event classRepAuthorized(bytes32 course, address courseRep);
    event classRepRevoked(bytes32 course, address courseRep);
    event studentCreation(bytes32 indexed name, uint256 indexed age, address indexed studentAddress);

    function authorizeCourseRep(bytes32 _course, address[] memory _courseRep, bool _isAuthenticated) external;
    function authorizedCourseReps(bytes32, address) external view returns (bool);
    function createStudent(Student memory _students) external;
    function createStudents(Student[] memory _students) external;
    function deregisterStudent(bytes32 _course, uint256 _studentId) external;
    function getStudent(uint256 _studentId) external view returns (Student memory student_);
    function getStudentByCourse(bytes32 _course, uint256 _studentId) external view returns (Student memory student_);
    function incrementAttendance(bytes32 _course, uint256 _studentId) external;
    function incrementAttendances(bytes32 _course, uint256[] memory _studentIds) external;
    function owner() external view returns (address);
    function registerStudent(bytes32 _course, uint256 _studentId) external;
    function studentCount() external view returns (uint256);
}
