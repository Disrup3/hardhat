import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect, assert } from "chai";
import { ethers } from "hardhat";


describe("NFT CONTRACT", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployNFTFixture() {

    return {  };
  }

  // testear que se crea una apuesta correctamente 
  describe("Funcionalidad de minteo", function() {
    it("Mintear un nft en fase whitelist y en fase normal", async () => {
       
    })

    it("Checkear que el uri se retorna correctamente", async () => {
        

    })
  })

});