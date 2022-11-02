// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./DistributeFunding.sol";

contract CrowdFunding {
    enum FundingState{ UNFINANCED, PREFINANCED, FINANCED }

    struct Contributor {
        uint256 sum;
    }

    mapping(address => Contributor) public contributors;

    uint256 public fundingGoal;
    uint256 public currentFundingSum;
    FundingState public state;
    // DistributeFunding private distributeFunding;

    constructor(uint256 _fundingGoal/*, address payable _distributeFunding*/) {
        fundingGoal = _fundingGoal;
        currentFundingSum = 0;
        state = FundingState.UNFINANCED;
        // distributeFunding = DistributeFunding(_distributeFunding);
    }

    function pledge() public payable {
        require(state == FundingState.UNFINANCED, "Cannot pledge, state is not UNFINANCED.");

        contributors[msg.sender].sum += msg.value;
        currentFundingSum += msg.value;

        if (currentFundingSum >= fundingGoal) {
            state = FundingState.PREFINANCED;
            // notifyFundingStateFinanced();
        }
    } 

    function retrieve(uint256 amount) public {
        require(state == FundingState.UNFINANCED, "Cannot retrieve, state is not UNFINANCED.");
        require(amount <= contributors[msg.sender].sum, "Smaller sum present in your contributor account.");

        payable(msg.sender).transfer(amount);

        contributors[msg.sender].sum -= amount;
        currentFundingSum -= amount;
    }

    function notifyFundingStateFinanced() public {
        require(state == FundingState.PREFINANCED, "Cannot be sponsored, state is not PREFINANCED.");

        state = FundingState.FINANCED;
    }

    // function transferToDistributeFundingContract() public {
    //     require(state == FundingState.FINANCED, "Cannot transfer balance to Distributor, state is not FINANCED.");

    //     payable(address(distributeFundingContract)).transfer(address(this).balance);
    // }

    function getBalance() public view returns(uint256){
        return address(this).balance;
    }

    function getState() public view returns(FundingState) {
        return state;
    }

    receive() external payable {

    }

    fallback() external payable {

    }
}
