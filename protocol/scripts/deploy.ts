/* eslint-disable @typescript-eslint/no-explicit-any */
import fs from "fs";
import { ethers, network, run } from "hardhat";
import path from "path";

function delay(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying Protocol..");

  console.log("NETWORK ID", network.config.chainId);
  console.log("Deploying contracts with the account:", deployer.address);

  const args: any[] = [];
  const Message = await ethers.getContractFactory("Message");
  const message = await Message.deploy(...args);

  await message.waitForDeployment();
  // await message.deployed()

  console.log("Deployment addresses:");
  console.log("Message:", await message.getAddress());

  const filePath = path.join(
    __dirname,
    "..",
    "deployments",
    `deployment.${network.config.chainId}.json`,
  );
  const deployments = {
    [`${network.config.chainId}`]: {
      Message: await message.getAddress(),
    },
  };

  fs.writeFileSync(filePath, JSON.stringify(deployments, null, 2));

  // Skip if the network is local or hardhat
  if (network.config.chainId === 31337 || network.config.chainId === 1337) {
    console.log("Skipping verification..");
    return;
  }

  console.log("Waiting for 30 seconds..");
  await delay(30000);

  console.log("Verifying Message contract..");
  await run("verify:verify", {
    address: await message.getAddress(),
    constructorArguments: args,
    contract: "contracts/Message.sol:Message",
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
