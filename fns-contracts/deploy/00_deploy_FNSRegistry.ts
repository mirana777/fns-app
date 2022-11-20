import { ethers } from "hardhat";
import { DeployFunction } from "hardhat-deploy/dist/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { txParams } from "./helper";

const df: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
  const { deploy } = hre.deployments;
  const deployer = (await ethers.getSigners())[0];
  const provider = deployer.provider!;
  const feeData = await provider.getFeeData();

  const registry = await deploy("FNSRegistry", {
    from: deployer.address,
    args: [],
    ...txParams(feeData),
    log: true,
  });
  if (!registry.newlyDeployed) {
    return;
  }
};

df.id = "FNSRegistry";
df.tags = ["registry"];
df.dependencies = [];
export default df;