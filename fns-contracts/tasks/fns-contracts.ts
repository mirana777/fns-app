import { task } from "hardhat/config";

task("fns-contracts", "Print all deployed contracts' addresses")
  .setAction(async ({ }, hre) => {
    const contracts = [
      ["FNSRegistry"],
      ["ReverseRegistrar"],
      ["Registrar"],
      ["FixedPriceOracle"],
      ["RegistrarController"],
      ["PublicResolver"],
    ];
    for (const cn of contracts) {
      const contract = await ethers.getContract(cn);
      console.log(`${cn}: ${contract.address}`);
    }
  });