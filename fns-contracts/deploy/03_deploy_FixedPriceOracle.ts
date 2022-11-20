import { ethers } from "hardhat";
import { DeployFunction } from "hardhat-deploy/dist/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { txParams } from "./helper";

const df: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
  const { deploy } = hre.deployments;
  const [deployer] = await ethers.getSigners();
  const provider = deployer.provider!;
  const feeData = await provider.getFeeData();

  const deployed = await deploy("FixedPriceOracle", {
    from: deployer.address,
    args: [],
    ...txParams(feeData),
    log: true,
  });
  if (!deployed.newlyDeployed) {
    return;
  }
};

df.id = "FixedPriceOracle";
df.tags = ["registrar", "FixedPriceOracle"];
df.dependencies = [];
export default df;