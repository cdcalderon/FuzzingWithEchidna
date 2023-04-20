pragma solidity ^0.8.17;

import {Dex, SwappableToken} from "./Dex.sol";

contract DexEchidnaTest {
    Dex dexContract;
    SwappableToken tradableToken1;
    SwappableToken tradableToken2;
    uint256 private constant INITIAL_SUPPLY = 10 ether;

    constructor() {
        dexContract = new Dex();
        tradableToken1 = new SwappableToken(
            address(dexContract),
            "Token1",
            "TK1",
            INITIAL_SUPPLY
        );
        tradableToken2 = new SwappableToken(
            address(dexContract),
            "Token2",
            "TK2",
            INITIAL_SUPPLY
        );
        dexContract.setTokens(address(tradableToken1), address(tradableToken2));
        dexContract.renounceOwnership();
    }

    //This test checks if the balance remains above 75 ether after performing swaps.

    function testTokenSwaps(uint256 _amount, bool _swapDirection) public {
        // Set the source and target tokens based on the swap direction.
        SwappableToken sourceToken = _swapDirection
            ? tradableToken1
            : tradableToken2;
        SwappableToken targetToken = _swapDirection
            ? tradableToken2
            : tradableToken1;

        // Restrict the staked amount to be less than 10 ether.
        uint256 inputAmount = _amount % INITIAL_SUPPLY;

        // Perform the swap and check token balances.
        performSwapAndCheckBalances(sourceToken, targetToken, inputAmount);
    }

    function performSwapAndCheckBalances(
        SwappableToken sourceToken,
        SwappableToken targetToken,
        uint256 inputAmount
    ) internal {
        // Approve the Dex contract to transfer tokens on behalf of the Echidna test contract.
        dexContract.approve(address(dexContract), inputAmount);

        // Perform the token swap.
        dexContract.swap(
            address(sourceToken),
            address(targetToken),
            inputAmount
        );

        // Check if the token balances in the Dex contract remain above 75 ether.
        assert(
            dexContract.balanceOf(address(sourceToken), address(dexContract)) >=
                75 ether
        );
        assert(
            dexContract.balanceOf(address(targetToken), address(dexContract)) >=
                75 ether
        );
    }

    // function testUserBalanceAfterSwaps(
    //     uint256 _stakedAmount,
    //     bool _fromContract
    // ) public {
    //     // Determine the source and target token addresses based on the _fromContract parameter.
    //     address fromContract = _fromContract
    //         ? address(tradableToken1)
    //         : address(tradableToken2);
    //     address toContract = _fromContract
    //         ? address(tradableToken2)
    //         : address(tradableToken1);

    //     // Ensure the staked amount is within the valid range (0 to 10 ether).
    //     uint256 stakedAmount = _stakedAmount % 10 ether;

    //     // Approve the Dex contract to handle the staked amount of tokens on behalf of the test contract.
    //     dexContract.approve(address(dexContract), stakedAmount);

    //     // Perform the token swap.
    //     dexContract.swap(fromContract, toContract, stakedAmount);

    //     // Get the balance of the first token in the test contract's address.
    //     uint256 userBalanceToken1 = dexContract.balanceOf(
    //         address(tradableToken1),
    //         address(this)
    //     );

    //     // Get the balance of the second token in the test contract's address.
    //     uint256 userBalanceToken2 = dexContract.balanceOf(
    //         address(tradableToken2),
    //         address(this)
    //     );

    //     // Assert that the combined value of both tokens in the test contract's address doesn't exceed 20 ether.
    //     assert(userBalanceToken1 + userBalanceToken2 <= 20 ether);
    // }
}
