
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract SponsorFunding {

    uint256 private procentage;
    uint256 private sponsorBalance;
    address payable private owner;
    bool private moneySent = false;

    constructor() payable{
        sponsorBalance = msg.value;
        procentage = 10;
        owner = payable(msg.sender);
    }

    function setContract(uint256 _newProcentage) external payable{
        require(msg.sender == owner, "Only the owner can call this function");
        procentage = _newProcentage;
        sponsorBalance = msg.value;

    }

    function addSponsorFunding(uint sumSent, address receiver) payable external {
        moneySent = false;
        if(sumSent/procentage <= sponsorBalance){
            payable(receiver).transfer(sumSent/procentage);
            moneySent = true;
        } else {
            revert("Insufficient funds!");
        }
    } 

    function notifyFundingStateChanged() public view returns(bool){
        return moneySent;
    }

    function getBalance() public view returns(uint256){
        return address(this).balance;
    }
}
