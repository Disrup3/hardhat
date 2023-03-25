import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv";
import "@nomiclabs/hardhat-etherscan";
import  "solidity-coverage";
import "hardhat-gas-reporter";

dotenv.config()

const config: HardhatUserConfig = {
  solidity: "0.8.18", 
  networks: {
    goerli: {
      url: process.env.PROVIDER_URL_GOERLI!,
      accounts: [process.env.ACCOUNT1!],        
    }
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    /*apiKey: process.env.ETHERSCAN!*/
  },
  gasReporter: {
    currency: 'EUR',
    gasPrice: 21,
    enabled: false
  }
};

export default config;
