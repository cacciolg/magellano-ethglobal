import { ethers, network, run } from "hardhat";

export async function main() {
  // const [owner] = await ethers.getSigners();

  const registry = await ethers.getContractAt("Registry", "0x..TODO");
  const twitterData = await ethers.getContractAt("TwitterData", "0x..TODO");

  console.log("NETWORK ID:", network.config.chainId);
  console.log("Registry:", await registry.getAddress());
  console.log("TwitterData:", await twitterData.getAddress());

  // Skip if the network is local or hardhat
  if (network.config.chainId === 31337 || network.config.chainId === 1337) {
    console.log("Skipping verification..");
    return;
  }

  console.log("Verifying Registry contract..");
  try {
    await run("verify:verify", {
      address: await registry.getAddress(),
      constructorArguments: [],
      contract: "contracts/Registry.sol:Registry",
    });
  } catch (e) {
    console.log(e);
  }

  console.log("Verifying TwitterData contract..");
  try {
    await run("verify:verify", {
      address: await twitterData.getAddress(),
      constructorArguments: [],
      contract: "contracts/licenses/TwitterData.sol:TwitterData",
    });
  } catch (e) {
    console.log(e);
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
