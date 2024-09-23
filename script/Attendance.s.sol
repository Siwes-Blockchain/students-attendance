// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Attendance} from "../src/Attendance.sol";

contract AttendanceScript is Script {
    function run() external {
        uint256 lecturerPrivateKey = vm.envUint("PRIVATE_KEY");

        // proposed coursereps addresses
        address mide = 0x6A03727F9ef2eA8fb9066A0Ec327eAE3e948403e;
        address nuel = 0xd05d9Fd4c48d2aa9E284AF2b501F714f65a5D5D8;

        address[] memory courseReps_ = new address[](2);
        courseReps_[0] = mide;
        courseReps_[1] = nuel;

        // proposed courses
        bytes32 CSC201 = keccak256("csc201");
        bytes32 CSC202 = keccak256("csc202");

        vm.startBroadcast(lecturerPrivateKey);

        Attendance attendance = new Attendance();
        attendance.authorizeCourseRep(CSC201, courseReps_, true);
        attendance.authorizeCourseRep(CSC202, courseReps_, true);

        vm.stopBroadcast();
    }
}