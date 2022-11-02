// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract DistributeFunding {

    struct Stakeholder {
        uint256 stake;
        address addr;
    }

    Stakeholder[] public stakeholders;

    constructor() payable {}

    function addStakeholder(uint256 _stake) public {
        stakeholders.push(Stakeholder({
            stake: _stake,
            addr: msg.sender
        }));
    }

    function distributeFunds() public {
        require(address(this).balance > 0, "No funds to distribute");

        uint256 originalBalance = address(this).balance;

        for(uint256 i = 0; i < stakeholders.length; i++) {
            payable(stakeholders[i].addr).transfer(originalBalance * stakeholders[i].stake / 100);
        }
    }

    receive() payable external{}

    fallback () external {}
}
