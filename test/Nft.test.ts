import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect, assert } from "chai";
import { ethers } from "hardhat";


describe("NFT CONTRACT", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployNFTFixture() {

    const [owner, add1] = await ethers.getSigners();

    const Contract = await ethers.getContractFactory("MrCrypto");
    const mrc = await Contract.deploy("name", "symbol");

    return { mrc, owner, add1 };
  }

  // testear que se crea una apuesta correctamente 
  describe("Funcionalidad de minteo", function() {
    xit("Mintear un nft en fase whitelist y en fase normal", async () => {
       const {mrc, add1, owner} = await deployNFTFixture();
        await mrc.addToWhitelist(add1.address);
        await mrc.addToWhitelist(owner.address);
        await mrc.mint(1, {value: ethers.utils.parseEther("1")})
        assert( await mrc.isWhitelisted(add1.address) === true);
    })

    xit("Checkear que el uri se retorna correctamente", async () => {
        const {mrc, owner} = await deployNFTFixture();

        // not revealed uri
        assert( await mrc.tokenURI(1) === "hola")

        // revealed uri
        await mrc.reveal();
        assert(await mrc.tokenURI(1) === "hola/1.json");
    })  
    
    xit("mint multiple nfts", async () => {
      const {mrc, owner} = await deployNFTFixture()
      await mrc.addToWhitelist(owner.address);

      await mrc.mint(2, {value: ethers.utils.parseEther("2")});
      
      assert(await mrc.ownerOf(1) === owner.address)
      assert(await mrc.ownerOf(2) === owner.address)

    }) 

    it("should rever in onlyAdmin functions", async () => {
      const {mrc, add1} = await deployNFTFixture();
      await expect(mrc.connect(add1).addToWhitelist(add1.address)).to.be.revertedWith("not admin")
    })


  })

});