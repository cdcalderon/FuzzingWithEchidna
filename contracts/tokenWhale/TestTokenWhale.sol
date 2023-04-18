//SPDX-License-Identifier: MIT
pragma solidity 0.4.25;

import "./TokenWhaleChallenge.sol";

contract TestTokenWhale is TokenWhaleChallenge {
    address echidna_caller = msg.sender;

    constructor() public TokenWhaleChallenge(echidna_caller) {}

    function echidna_test_balance() public view returns (bool) {
        return balanceOf[echidna_caller] < 1000000;
    }

    // function echidna_test_balance() public view returns (bool) {
    //     return balanceOf[echidna_caller] <= totalSupply;
    // }

    //  function echidna_test_balance() public view returns (bool) {
    //     return !isComplete();
    // }

    // function echidna_test_transfer() public {
    //     uint256 balanceBefore = balanceOf[address(this)];
    //     uint256 amountToTransfer = balanceBefore / 2;

    //     transfer(address(this), amountToTransfer);

    //     uint256 balanceAfter = balanceOf[address(this)];
    //     assert(balanceAfter == balanceBefore);
    // }

    // function echidna_test_approve_and_transferFrom() public {
    //     uint256 balanceBefore = balanceOf[address(this)];
    //     uint256 amountToTransfer = balanceBefore / 2;
    //     approve(address(this), amountToTransfer);

    //     transferFrom(address(this), address(this), amountToTransfer);

    //     uint256 balanceAfter = balanceOf[address(this)];
    //     assert(balanceAfter == balanceBefore);
    // }
}
