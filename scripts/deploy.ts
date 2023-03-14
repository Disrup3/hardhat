import { ethers } from "hardhat";

async function main() {
  const NAME = "Bets";
  const SYMBOL = "BTS";
  const INITIAL_SUPPLY = 1000;  

  // Contracts are deployed using the first signer/account by default
  // hacemos fetch a "wallets" de hardhat
  const signers = await ethers.getSigners();
  console.log(signers);
  // Desplegamos un contrato
  const MockToken = await ethers.getContractFactory("MockToken");
  const mocktoken = await MockToken.deploy(NAME, SYMBOL, INITIAL_SUPPLY);

  const BetsContract = await ethers.getContractFactory("Bets");
  const betsContract = await BetsContract.deploy(mocktoken.address);

  console.log(`direccion de bets - ${betsContract.address} | direccion token ${mocktoken.address}`)
  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
