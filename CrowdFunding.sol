// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding {
    enum FundingState{ UNFINANCED, PREFINANCED, FINANCED }

    struct Contributor {
        uint256 sum;
    }

    FundingState public state;
    uint256 public fundingGoal;
    uint256 public currentFundingSum;
    mapping(address => Contributor) public contributors;

    constructor(uint256 _fundingGoal) {
        fundingGoal = _fundingGoal;
        currentFundingSum = 0;
        state = FundingState.UNFINANCED;
    }

    function pledge() public payable {
        require(state == FundingState.UNFINANCED, "Funding is no longer available.");

        contributors[msg.sender].sum += msg.value;
        currentFundingSum += msg.value;

        if (currentFundingSum >= fundingGoal) {
            state = FundingState.PREFINANCED;
        }
    } 

    function retrieve(uint256 amount) public {
        require(state == FundingState.UNFINANCED, "Retrieval is no longer available.");
        require(amount <= contributors[msg.sender].sum, "Smaller sum present in your contributor account.");

        payable(msg.sender).transfer(amount);

        contributors[msg.sender].sum -= amount;
        currentFundingSum -= amount;
    }
}