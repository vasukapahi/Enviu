// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ServerManagement {

    address public owner;
    uint256 public thresholdPerformance;
    uint256 public sleepTime;
    bool public isServerActive;

    event HibernateEvent(address indexed serverAddress, uint256 utilization);
    event WakeUpEvent(address indexed serverAddress);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyWhenActive() {
        require(isServerActive, "Server is not currently active");
        _;
    }

    constructor(uint256 _thresholdPerformance, uint256 _sleepTime) {
        owner = msg.sender;
        thresholdPerformance = _thresholdPerformance;
        sleepTime = _sleepTime;
        isServerActive = true;
    }

    function updatethresholdPerformance(uint256 _newThreshold) external onlyOwner {
        thresholdPerformance = _newThreshold;
    }

    function updatesleepTime(uint256 _newsleepTime) external onlyOwner {
        sleepTime = _newsleepTime;
    }

    function checkServerUtilization(uint256 _utilization) external onlyOwner onlyWhenActive {
        if (_utilization < thresholdPerformance) {
            isServerActive = false;
            emit HibernateEvent(address(this), _utilization);
            
        }
    }

    function wakeUpServer() external onlyOwner {
        require(!isServerActive, "Server is already active");
        isServerActive = true;
        emit WakeUpEvent(address(this));
    }
}
