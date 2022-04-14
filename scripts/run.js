const main = async () => {
	const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
	const waveContract = await waveContractFactory.deploy({
		value: hre.ethers.utils.parseEther("0.1"),
	});
	await waveContract.deployed();
	console.log("Contract deployed to:", waveContract.address);

	let contractBalance = await hre.ethers.provider.getBalance(
		waveContract.address
	);
	console.log(
		"contract balance",
		hre.ethers.utils.formatEther(contractBalance)
	);

	let waveCount;
	waveCount = await waveContract.getTotalWaves();
	console.log(waveCount.toNumber());

	let waveTxn1 = await waveContract.wave("msg #1");
	await waveTxn1.wait();

	contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
	console.log(
		"contract balance",
		hre.ethers.utils.formatEther(contractBalance)
	);

	let allWaves = await waveContract.getAllWaves();
	console.log(allWaves);
};

const runMain = async () => {
	try {
		await main();
		process.exit(0);
	} catch (error) {
		console.error(error);
		process.exit(1);
	}
};

runMain();
