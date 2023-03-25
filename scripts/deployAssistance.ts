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
  const MockToken = await ethers.getContractFactory("D3Token");
  const mocktoken = await MockToken.deploy();

   const Assistance = await ethers.getContractFactory("Assistance");
    const assistance = await Assistance.deploy(mocktoken.address);
    const pass = ethers.utils.solidityKeccak256(["string"], ["hola"])
    await assistance.createClass(pass, true);

  console.log(`direccion de assistance - ${assistance.address} | direccion token ${mocktoken.address}`)
  const tx = await assistance.currentClassId()
  console.log(await assistance._admins(signers[0].address))
  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
