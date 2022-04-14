pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver; //the waver address
        string message; // the message sent by waver
        uint256 timestamp; // the timestamp of the message
    }

    Wave[] waves;

    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("Yo, yo, I am a contract and I am smart");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m to wave again"
        );

        lastWavedAt[msg.sender] = block.timestamp;
        totalWaves += 1;
        console.log("%s waved with message %s", msg.sender, _message);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("random # generated: %d", seed);

        if (seed <= 10) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has"
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withraw moeny from contract");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves", totalWaves);
        return totalWaves;
    }
}