#!/bin/bash

# load env file
source .env

# To deploy and verify our contract
forge script --chain sepolia script/Attendance.s.sol:AttendanceScript \
    --rpc-url $SEPOLIA_RPC_URL --broadcast --verify -vvvv
