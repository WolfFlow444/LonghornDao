// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Governance is ERC20 {

  constructor() 
  ERC20("LonghornDao", "LHD")
  {}

  struct Account {
    uint256 userTotalVER;
  }

  struct Deposit {
    uint256 amount;
    uint256 timestamp;
    uint256 lockedUntil;
    uint256 veAmount;
  }

  mapping (address => Deposit) votedEscrowLHDao;
  mapping (address => Account) userGovernanceData;
  uint256 totalVER;

  function stake(uint256 amount, uint256 numWeeks) public returns (bool) {
    uint256 escrowAmount = (1 + (numWeeks)) * amount; // come back to this later
    transferFrom(msg.sender, address(this), amount);
    Deposit memory d = Deposit (amount, block.timestamp, block.timestamp * numWeeks * 604800, escrowAmount);
    votedEscrowLHDao[msg.sender] = d;
    totalVER += escrowAmount;
    userGovernanceData[msg.sender].userTotalVER += escrowAmount;
    return true;
  }

  function unstake(uint256 amount) public returns (bool) { // fix function inputs (deposit ID)
    require(votedEscrowLHDao[msg.sender].lockedUntil <= block.timestamp);
    transfer(msg.sender, votedEscrowLHDao[msg.sender].amount);
    userGovernanceData[msg.sender].userTotalVER -= votedEscrowLHDao[msg.sender].amount;
    delete votedEscrowLHDao[msg.sender];
    return true;
  }

}
