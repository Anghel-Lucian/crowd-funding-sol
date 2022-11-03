
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./CrowdFunding.sol";

contract SponsorFunding {
    enum FundingState{ UNFINANCED, PREFINANCED, FINANCED }

    uint256 private procentage;
    uint256 private sponsorBalance;
    address private owner;
    CrowdFunding private crowdFunding;

    constructor(address payable _crowdFunding, uint256 _procentage) payable {
        sponsorBalance = msg.value;
        procentage = _procentage;
        owner = msg.sender;
        crowdFunding = CrowdFunding(_crowdFunding);
    }

    function addSponsorFunding() public payable {
        require(crowdFunding.getBalance()/procentage <= sponsorBalance, "Insufficient funds for sponsorship.");
            
        payable(address(crowdFunding)).transfer(crowdFunding.getBalance()/procentage);

        crowdFunding.notifyFundingStateFinanced();
    } 

    function getBalance() public view returns(uint256){
        return address(this).balance;
    }

    fallback() external payable {
        payable(address(crowdFunding)).transfer(msg.value);
    }

    receive() external payable {}
}
