import { namehash } from "ethers/lib/utils";
import { ethers } from "hardhat";
import { DeployFunction } from "hardhat-deploy/dist/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { AddressZero, isEqualIgnoreCase, txParams } from "../helper";

const PubResolverName = "resolver.fil";
const PubResolverNode = namehash(PubResolverName);

const df: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
  const { deploy } = hre.deployments;
  const [deployer] = await ethers.getSigners();
  const owner = deployer;
  const provider = deployer.provider!;
  const overrides = txParams(await provider.getFeeData());

  const registry = await ethers.getContract("FNSRegistry", owner);
  const controller = await ethers.getContract("RegistrarController", owner);
  const reverseRegistrar = await ethers.getContract("ReverseRegistrar", owner);

  const deployed = await deploy("PublicResolver", {
    from: deployer.address,
    args: [registry.address, controller.address, reverseRegistrar.address],
    ...overrides,
    log: true,
  });
  // if (!deployed.newlyDeployed) {
  //   return;
  // }
  const resolver = await ethers.getContract("PublicResolver", owner);

  if (await reverseRegistrar.defaultResolver() == AddressZero) {
    console.log(`Setting default resolver on ReverseRegistrar to PublicResolver ...`,);
    const tx = await reverseRegistrar.setDefaultResolver(resolver.address, overrides);
    console.log(`> tx: ${tx.hash})`);
    await tx.wait();
  }

  const registrar = await ethers.getContract("Registrar", owner);
  if (await registry.resolver(await registrar.baseNode()) == ethers.constants.AddressZero) {
    console.log(`Setting resolver for Registrar to PublicResolver`);
    const tx = await registrar.setResolver(resolver.address, overrides);
    console.log(`> tx: ${tx.hash}`);
    await tx.wait();
  }

  if (isEqualIgnoreCase(owner.address, await registry.owner(PubResolverNode))) {
    console.log(`Setting resolver for ${PubResolverName} to PublicResolver ...`,);
    const tx1 = await registry.setResolver(PubResolverNode, resolver.address, overrides);
    console.log(`> tx: ${tx1.hash}`);
    await tx1.wait();

    console.log(`Setting address for ${PubResolverName} to PublicResolver ...`);
    const tx2 = await resolver["setAddr(bytes32,address)"](PubResolverNode, resolver.address, overrides);
    console.log(`> tx: ${tx2.hash}`);
    await tx2.wait();
  } else {
    console.log(
      `${PubResolverName} is not owned by the owner address, not setting resolver`,
    );
  }
};

df.id = "PublicResolver";
df.tags = ["resolver"];
df.dependencies = ["registry", "reverse", "registrar"];
export default df;