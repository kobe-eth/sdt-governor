
import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-vyper";

export default {
  defaultNetwork: "hardhat",
  solidity: {
    version: "0.8.15"
  },
  vyper: {
    version: "0.2.16"
  },
  // specify separate cache for hardhat, since it could possibly conflict with foundry's
  paths: {
    cache: "cache-hh",
    artifacts: "./artifacts-hh",
  },
} as HardhatUserConfig;