// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

error NotOwner();

contract Owned {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if(msg.sender != owner) revert NotOwner();
        _;
    }
}