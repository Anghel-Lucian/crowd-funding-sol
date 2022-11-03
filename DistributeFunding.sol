// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract DistributeFunding {

    struct Stakeholder {
        uint256 stake;
        bool retrieved;
    }
    
    uint256 public fundingSum;
    mapping(address => Stakeholder) public stakeholders;

    constructor() payable {}

    function addStakeholder(uint256 _stake) public {
        stakeholders[msg.sender].stake = _stake;
        stakeholders[msg.sender].retrieved = false;
    }

    function retrieve() public {
        require(address(this).balance > 0, "No funds to distribute");
        require(!stakeholders[msg.sender].retrieved, "Stake already retrieved");
        require(stakeholders[msg.sender].stake > 0, "Stake is 0");

        payable(msg.sender).transfer(fundingSum * stakeholders[msg.sender].stake / 100);
        stakeholders[msg.sender].retrieved = true;
    }

    function setFundingSum(uint256 _fundingSum) public {
        fundingSum = _fundingSum;
    }

    receive() payable external {}

    fallback() external payable {}
}
