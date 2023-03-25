import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect, assert } from "chai";
import { ethers } from "hardhat";

const INITIAL_SUPPLY = 1000;

describe("BETS CONTRACT", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployBetsFixture() {
    const NAME = "Bets";
    const SYMBOL = "BTS";
    

    // Contracts are deployed using the first signer/account by default
    // hacemos fetch a "wallets" de hardhat
    const [owner, add1, add2] = await ethers.getSigners();

    // Desplegamos un contrato
    const MockToken = await ethers.getContractFactory("MockToken");
    const mocktoken = await MockToken.deploy(NAME, SYMBOL, INITIAL_SUPPLY);

    const BetsContract = await ethers.getContractFactory("Bets");
    const betsContract = await BetsContract.deploy(mocktoken.address);

    return { owner, add1, add2, mocktoken, betsContract };
  }

  // testear que se crea una apuesta correctamente 
  describe("funcionalidad de apuestas", function() {
    it("crear apuesta", async () => {
        const { betsContract } = await deployBetsFixture()

        
        // llamamos al contrato para crear una apuesta
        await betsContract.createGame(1, 0 , 0);
        // checkeamos que esta apuesta se haya creado 
        expect(await betsContract.games(0)).to.exist;
        // "llamando a la funcion publica games en el idx 0"
    })

    it("apostar", async () => {
        const { mocktoken, betsContract, add1, owner } = await deployBetsFixture();

        const BET_AMOUNT = ethers.utils.parseEther("100")

        await betsContract.createGame(1, 0 , 0);
        await mocktoken.approve(betsContract.address, BET_AMOUNT);

        await betsContract.bet(0, 1, BET_AMOUNT);
        
        const tx = await betsContract.userBets(0, owner.address, 0);

        expect(tx).to.be.equal(BET_AMOUNT); 
        expect(tx).to
        .emit(mocktoken, "Transfer")
        .withArgs(owner.address, betsContract.address, BET_AMOUNT);

        await mocktoken.connect(add1).mint();
        await mocktoken.connect(add1).approve(betsContract.address, BET_AMOUNT);
        await betsContract.connect(add1).bet(0, 2, BET_AMOUNT);

        await expect(betsContract.setWinner(0, 2)).to.be.revertedWith("game hasn't finished");

        const latestTime = await time.latest();
        await time.increase(latestTime + 60 * 60 * 2);

        await betsContract.setWinner(0, 1);
        await betsContract.claimReward(0);

        console.log(await mocktoken.balanceOf(owner.address));
        
        expect(await mocktoken.balanceOf(owner.address)).to.be.greaterThan(INITIAL_SUPPLY);

       

    })
  })

});