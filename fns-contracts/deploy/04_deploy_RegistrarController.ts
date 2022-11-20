import { ethers } from "hardhat";
import { DeployFunction } from "hardhat-deploy/dist/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { txParams } from "./helper";

const df: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
  const { deploy } = hre.deployments;
  const [deployer] = await ethers.getSigners();
  const owner = deployer;
  const provider = deployer.provider!;
  const overrides = txParams(await provider.getFeeData());

  const registrar = await ethers.getContract("Registrar", owner);
  const priceOracle = await ethers.getContract("FixedPriceOracle");
  const reverseRegistrar = await ethers.getContract("ReverseRegistrar", owner);

  const deployed = await deploy("RegistrarController", {
    from: deployer.address,
    args: [registrar.address, priceOracle.address, reverseRegistrar.address],
    ...overrides,
    log: true,
  });
  // if (!deployed.newlyDeployed) {
  //   return;
  // }
  const controller = await ethers.getContract("RegistrarController");

  if (!await registrar.controllers(controller.address)) {
    console.log(`Adding RegistrarController as controller of Registrar ...`);
    const tx = await registrar.addController(controller.address, overrides);
    console.log(`tx: ${tx.hash}`);
    await tx.wait();
  }

  if (!await reverseRegistrar.controllers(controller.address)) {
    console.log(`Adding RegistrarController as controller of ReverseRegister ...`);
    const tx = await reverseRegistrar.setController(controller.address, true, overrides);
    console.log(`> tx: ${tx.hash}`);
    await tx.wait();
  }
};

df.id = "registrar";
df.tags = ["registrar", "RegistrarController"];
df.dependencies = ["registry", "reverse", "Registrar", "FixedPriceOracle"];
export default df;