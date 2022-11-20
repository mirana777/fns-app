import { keccak256, namehash, toUtf8Bytes } from "ethers/lib/utils";
import { ethers } from "hardhat";
import { DeployFunction } from "hardhat-deploy/dist/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { isEqualIgnoreCase, labelhash, RootNode, txParams } from "./helper";

const TldName = "reverse";
const TldLable = labelhash(TldName);
const TldNode = namehash(TldName);
const AddrName = `addr.${TldName}`;
const AddrLable = labelhash("addr");
const AddrNode = namehash(AddrName);

const df: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
  const { deploy } = hre.deployments;
  const [deployer] = await ethers.getSigners();
  const owner = deployer;
  const provider = deployer.provider!;
  const overrides = txParams(await provider.getFeeData());

  const registry = await ethers.getContract("FNSRegistry", owner);

  const deployed = await deploy('ReverseRegistrar', {
    from: deployer.address,
    args: [registry.address],
    ...overrides,
    log: true,
  });
  // if (!deployed.newlyDeployed) {
  //   return;
  // }
  const reverseRegistrar = await ethers.getContract("ReverseRegistrar", owner);

  const tldOwner = await registry.owner(TldNode);
  if (!isEqualIgnoreCase(tldOwner, owner.address)) {
    console.log(`Setting owner of node ${TldName} ...`);
    const tx = await registry.setSubnodeOwner(RootNode, TldLable, owner.address, overrides);
    console.log(`> tx: ${tx.hash}`);
    await tx.wait();
  }

  const addrOwner = await registry.owner(AddrNode);
  if (!isEqualIgnoreCase(addrOwner, reverseRegistrar.address)) {
    console.log(`Setting owner of node ${AddrName} to ReverseRegistrar ...`);
    const tx = await registry
      .setSubnodeOwner(
        TldNode,
        AddrLable,
        reverseRegistrar.address,
        overrides
      );
    console.log(`> tx: ${tx.hash}`);
    await tx.wait();
  }
};

df.id = "ReverseRegistrar";
df.tags = ["reverse"];
df.dependencies = ["registry"];
export default df;