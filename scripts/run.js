const main = async () => {
	const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
	const gameContract = await gameContractFactory.deploy(
		['_buildspace', 'OpenSea', 'Alchemy'], // Names
		[
			'https://api.typedream.com/v0/document/public/725f4e6f-9718-40b8-91d0-e952946234b9_image-removebg-preview_1_png.png', // Images
			'https://cdn.buildspace.so/companies/opensea/logo.png',
			'https://cdn.buildspace.so/companies/alchemy/logo.png',
		],
		[100, 200, 300], // HP values
		[100, 50, 25], // Attack damage values
		'Web 2.0', // Boss name
		'https://e7.pngegg.com/pngimages/347/552/png-clipart-web-2-internet-forum-tuk-tuk-taxi-text-service.png', // Boss image
		10000, // Boss hp
		50 // Boss attack damage
	);
	await gameContract.deployed();
	console.log('Contract deployed to:', gameContract.address);

	let txn;
	// We only have three characters.
	// an NFT w/ the character at index 2 of our array.
	txn = await gameContract.mintCharacterNFT(2);
	await txn.wait();

	txn = await gameContract.attackBoss();
	await txn.wait();

	txn = await gameContract.attackBoss();
	await txn.wait();

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
