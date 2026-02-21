import hre from "hardhat";

async function main() {
  console.log("Deploying V-Sentinel Registry...");
  const VehicleRegistry = await hre.ethers.getContractFactory("VehicleRegistry");
  const registry = await VehicleRegistry.deploy();
  await registry.waitForDeployment();

  console.log("\n✅ V-Sentinel Registry Deployed to:", await registry.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});