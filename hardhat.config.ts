import { HardhatUserConfig, task, types } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-ethers";
import "hardhat-deploy";
import "@typechain/hardhat";
import "solidity-coverage";
import { config as dotEnvConfig } from "dotenv";
dotEnvConfig();
const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.19",
    settings: { optimizer: { enabled: true, runs: 200 } },
  },
  networks: {
    bscTestnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      accounts: [process.env.KEY!],
      chainId: 97,
    },
  },
  gasReporter: {
    enabled: false,
    outputFile: "gas-report.txt",
    noColors: true,
    currency: "USD",
    coinmarketcap: "22",
    token: "BNB",
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
  },
};
task(
  "flat",
  "Flattens and prints contracts and their dependencies (Resolves licenses)"
)
  .addOptionalVariadicPositionalParam(
    "files",
    "The files to flatten",
    undefined,
    types.inputFile
  )
  .setAction(async ({ files }, hre) => {
    let flattened = await hre.run("flatten:get-flattened-sources", { files });

    // Remove every line started with "// SPDX-License-Identifier:"
    flattened = flattened.replace(
      /SPDX-License-Identifier:/gm,
      "License-Identifier:"
    );
    flattened = `// SPDX-License-Identifier: MIXED\n\n${flattened}`;

    // Remove every line started with "pragma experimental ABIEncoderV2;" except the first one
    flattened = flattened.replace(
      /pragma experimental ABIEncoderV2;\n/gm,
      (
        (i) => (m: any) =>
          !i++ ? m : ""
      )(0)
    );
    console.log(flattened);
  });
export default config;
