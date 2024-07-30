// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

error InvalidStudentId();
error NotOwner();
error Unauthorized();
error InvalidData();
error InvalidId();

contract Owned {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        // require(msg.sender == owner, "Caller is not the owner");
        if(msg.sender != owner) revert NotOwner();
        _;
    }
}


// struct to hold the `student` type
struct Student {
    uint256 age;
    uint256 attendanceCount;
    bytes32 name;
}

contract Attendance is Owned {

    // mapping of `Id` to `student`
    mapping(uint256 => Student) StudentsList;

    // mapping of authorized classreps
    mapping(address => bool) authorizedClassReps;

    // state to keep track of students Id
    uint256 public studentCount;

    // student creation event
    event studentCreationEvent(
        bytes32 name,
        uint256 age
    );

    // auth granted event
    event classRepAuthorized(address classRep);

    // auth revoke event
    event classRepRevoked(address classRep);

    // modifier for `owner` or `classrep` permission check
    modifier onlyAuthorized() {
        if(msg.sender != owner && !authorizedClassReps[msg.sender]) revert Unauthorized();
        _;
    }

    // set `classrep` auth for an address
    function authorizeClassRep(address _classRep) public onlyOwner {
        authorizedClassReps[_classRep] = true;
        emit classRepAuthorized(_classRep);
    }

    // revoke `classrep` auth for an address
    function revokeClassRep(address _classRep) public onlyOwner {
        authorizedClassReps[_classRep] = false;
        emit classRepRevoked(_classRep);
    }

    // creates a new student
    function createStudent(uint256 _age, bytes32 _name) external onlyOwner {
        Student storage student = StudentsList[studentCount++];
        student.age = _age;
        student.attendanceCount = 0;
        student.name = _name;
    }

    // creates students in batch
    function createStudents(uint256[] memory _ages, bytes32[] memory _names) external onlyOwner {
        if(_ages.length != _names.length) revert InvalidData();
        uint256 agesLen_ = _ages.length;
        for (uint256 i = 0; i < agesLen_ ; i++) {
            Student storage student = StudentsList[studentCount++];
            student.age = _ages[i];
            student.name = _names[i];
        }
    }

    // incrment attendance count for a student
    function incrementAttendance(uint256 _studentId) external onlyAuthorized {
        if(_studentId >= studentCount) revert InvalidStudentId();
        Student storage student = StudentsList[_studentId];
        student.attendanceCount++;
    }

    // increment attendance in batch
    function incrementAttendances(uint256[] memory _studentIds) external onlyAuthorized {
        for(uint i = 0; i < _studentIds.length; i++) {
            if(i >= studentCount) revert InvalidId();
            uint256 studentId_ = _studentIds[i];
            Student storage student = StudentsList[studentId_];
            student.attendanceCount++;
        }
    }

    // retrieve a student
    function getStudent(uint256 _studentId) external view returns(Student memory) {
        if(_studentId >= studentCount) revert InvalidStudentId();
        Student memory student = StudentsList[_studentId];
        return student;
    }

    // retrieve auth
    function isAuthorized(address _rep) public view returns(bool) {
        return authorizedClassReps[_rep];
    }
}