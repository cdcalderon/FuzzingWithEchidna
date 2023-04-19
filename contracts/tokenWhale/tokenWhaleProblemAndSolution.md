# Token Whale Challenge

The Token Whale Challenge is an ERC20 token contract with a fixed supply of 1,000 tokens. The contract's main purpose is to demonstrate an exploitable issue in the \_transfer() function, which causes an integer underflow when transferring tokens between wallets. In this challenge, you start as the owner of all 1,000 tokens, and the goal is to accumulate at least 1,000,000 tokens to solve the challenge.

## Introduction to Token Whale Challenge

The Token Whale Challenge contract has the following invariants:

- A fixed total supply of 1,000 tokens.
- The contract owner starts with the entire token supply.
- Token transfers should only occur when the sender has enough tokens.
- Approved spenders should be able to transfer tokens on behalf of token holders.

However, there's a vulnerability in the contract, specifically in the \_transfer() function, which we will exploit to accumulate more tokens than the initial fixed supply.

## The problem and the exploit

The problem lies in the \_transfer() function, an internal function responsible for updating address balances when a transfer occurs. The function subtracts the transfer value from msg.sender, regardless of whether the initiator is the token holder or an approved spender.

To exploit this vulnerability, follow these steps:

1. Call the `approve()` function to grant a secondary wallet (Wallet B) a token allowance. The value of this allowance can be any positive integer less than the uint256 upper limit (2\*\*256 - 1).

2. Switch to Wallet B, which has an initial balance of 0 tokens. Initiate a transfer from Wallet B to a third wallet (Wallet C) with a transfer value less than the approved allowance.

3. When Wallet B initiates the transfer, the `_transfer()` function incorrectly tries to subtract the transfer value from Wallet B's balance, which is 0.

4. Since the balance variables are unsigned integers (they can't be negative), the subtraction operation causes an underflow. As a result, Wallet B's balance is set to a massive number, close to the uint256 upper limit.

## Steps to reproduce and conclusion

Finally, to complete the challenge, transfer 1,000,000 tokens from Wallet B back to your original wallet (Wallet A). This will increase your balance to over 1,000,000 tokens, solving the challenge.

By exploiting the improper handling of balances in the `_transfer()` function and leveraging the underflow caused by subtracting a value from an empty wallet, you can accumulate more tokens than the initial fixed supply.
