import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { ethers, network } from "hardhat";
import { networkConfig } from "../helpers/hardhat-config";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  console.log("deploying...");
  const { getNamedAccounts, deployments } = hre;
  const { deploy, log } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = network.config.chainId!; //if undef localhost

  const de = await deploy("Detasker", {
    from: deployer,
    args: [deployer],
  });
};
export default func;
