// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.7.0;

import "./token.sol";

/// @dev Run the template with
///      ```
///      solc-select use 0.5.0
///      echidna program-analysis/echidna/exercises/exercise2/template.sol
///      ```
contract TestTokenExerciseTwo is Token {
    address echidna_caller = msg.sender;

    constructor() public {
        balances[echidna_caller] = 10000;
        pause(); // pause the contract
        owner = address(0); // lose ownership
    }

    function echidna_cannot_be_unpause() public view returns (bool) {
        return paused() == true;
    }

    // //assertion testing
    // function testPausable() public {
    //     assert(paused() == true);
    // }
}
