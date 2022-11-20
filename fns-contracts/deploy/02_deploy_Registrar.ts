import { namehash } from "ethers/lib/utils";
import { ethers } from "hardhat";
import { DeployFunction } from "hardhat-deploy/dist/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { Registrar } from "../typechain-types";
import { AddressZero, isEqualIgnoreCase, labelhash, RootNode, txParams } from "./helper";

const TldName = "fil";
const TldLabel = labelhash(TldName);
const TldNode = namehash(TldName);
const ReserveNames = ["resolver", "fns", "filfox", "foxwallet"];
const ReserveDuration = 3600 * 24 * 365 * 1024;

const df: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
  const { deploy } = hre.deployments;
  const [deployer] = await ethers.getSigners();
  const owner = deployer;
  const provider = deployer.provider!;
  const overrides = txParams(await provider.getFeeData());

  const registry = await ethers.getContract("FNSRegistry", owner);

  const deployed = await deploy("Registrar", {
    from: deployer.address,
    args: [registry.address, namehash(TldName)],
    ...overrides,
    log: true,
  });
  // if (!deployed.newlyDeployed) {
  //   return;
  // }
  const registrar: Registrar = await ethers.getContract("Registrar", owner);

  if (!await registrar.controllers(owner.address)) {
    console.log(`Adding owner as controller of Registrar ...`);
    const tx = await registrar.addController(owner.address, overrides);
    console.log(`> tx: ${tx.hash}`);
    await tx.wait();
  }

  const tldOwner = await registry.owner(TldNode);
  if (!isEqualIgnoreCase(tldOwner, registrar.address)) {
    const txNodeOwner = await registry.setSubnodeOwner(RootNode, TldLabel, registrar.address, overrides);
    console.log(
      `Setting owner of ${TldName} node to registrar (tx: ${txNodeOwner.hash})...`,
    );
    await txNodeOwner.wait();
  }

  for (const name of ReserveNames) {
    const id = labelhash(name);
    if (!await registrar.available(id)) {
      continue;
    }
    console.log(`Register reserve name: ${name} ...`);
    const tx = await registrar.register(name, owner.address, ReserveDuration, AddressZero, overrides);
    console.log(`> tx: ${tx.hash}`);
  }
};

df.id = "Registrar";
df.tags = ["registrar"];
df.dependencies = ["registry"];
export default df;