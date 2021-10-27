const main = async () => {
	const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
	const gameContract = await gameContractFactory.deploy(
		['_buildspace', 'OpenSea', 'Alchemy'], // Names
		[
			'https://ipfs.infura.io/ipfs/QmQ9yemquPAeK9xLVuoJJTvzpFM8CwKM5TDjJdHPL63m3y',
			'https://ipfs.infura.io/ipfs/QmZC7oink7ewA6PMUbbqWFFvhMWbBXn6nr4EDaWAhSqTrq',
			'https://ipfs.infura.io/ipfs/QmPyKP4gr8sYdpnu6nVe9fdshpZxHSKgS6dw3eQiwJcgGz',
		],
		[100, 200, 300], // HP values
		[100, 50, 25], // Attack damage values
		'Web 2.0', // Boss name
		// Boss image
		'https://ipfs.infura.io/ipfs/QmWffQcYPvdf5VLfqRFcBfZcLZHnGXwkCHiA9MZ4Fv4dmA',
		2000, // Boss hp
		50 // Boss attack damage
	);
	await gameContract.deployed();
	console.log('Contract deployed to:', gameContract.address);

	console.log('Done!');
};

const runMain = async () => {
	try {
		await main();
		process.exit(0);
	} catch (error) {
		console.log(error);
		process.exit(1);
	}
};

runMain();
