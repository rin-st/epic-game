const main = async () => {
	const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
	const gameContract = await gameContractFactory.deploy(
		// string[] memory characterNames,
		[
			{
				name: 'Leonardo',
				imageURI:
					'https://cloudflare-ipfs.com/ipfs/QmfNWKEVwkkBPdLknDYnCjpin1dWNUzTCqvTFj3JH4ENuE',
				attackImageURI:
					'https://cloudflare-ipfs.com/ipfs/QmQzVd5pWvEeSe3KbkUi2FEjuHDRm9z7GRAAdC1wMkqD38',
				eatImageURI:
					'https://cloudflare-ipfs.com/ipfs/QmPo8dqzuLo5uBfRB51bUJBw9MmpXHCWnARp5uq7qhdaPG',
				loseImageURI:
					'https://cloudflare-ipfs.com/ipfs/Qme2m3U463Wh8aXPqbor9WJZwpP2PSp1odyN4NqBnJPviJ',
				hp: 150,
				attackDamage: 50,
				healAmount: 80,
				criticalChance: 80,
			},
			{
				name: 'Raphael',
				imageURI:
					'https://cloudflare-ipfs.com/ipfs/QmbjZDCfFRyfR7vfKroptfPaamLge1LGWjnVnkxjeSAUhW',
				attackImageURI:
					'https://cloudflare-ipfs.com/ipfs/QmcZTReejQRya77RPUzpAqVQK229DfbcJr62iAX23QAwDA',
				eatImageURI:
					'https://cloudflare-ipfs.com/ipfs/QmaFrdpzaTYcu7nTJo8sBxKcTi1hA9cMcbuLT2efpkBNwA',
				loseImageURI:
					'https://cloudflare-ipfs.com/ipfs/QmUyfiC2CXppna8G9KBoJeogny1sx7J3wZFCo5RyTexnHo',
				hp: 200,
				attackDamage: 60,
				healAmount: 100,
				criticalChance: 60,
			},
			{
				name: 'Michelangelo',
				imageURI:
					'https://cloudflare-ipfs.com/ipfs/QmT9S25C8Jb8q4xFEPsdk6dZh68LmM3wF2zGHwNCqMKMiV',
				attackImageURI:
					'https://cloudflare-ipfs.com/ipfs/QmVonx2rB1926HXPTQrmNw3ZibzqH6Dud3co656Po7uzK9',
				eatImageURI:
					'https://cloudflare-ipfs.com/ipfs/QmR3hJ3AY3RRFRaKwoVEm9WeFQd1DZVYBX7YuoDBe9WGs3',
				loseImageURI:
					'https://cloudflare-ipfs.com/ipfs/QmXvnXSa5NRPxGMB6uwuvTdv3nER3L7fndxE76kfsv5YWg',
				hp: 250,
				attackDamage: 40,
				healAmount: 150,
				criticalChance: 40,
			},
			{
				name: 'Donatello',
				imageURI:
					'https://cloudflare-ipfs.com/ipfs/QmSTnbCDF9Zw3ECxwNagpLpSZf6XUBCz1ssej1kVRpuXnA',
				attackImageURI:
					'https://cloudflare-ipfs.com/ipfs/QmPkdKb9kBgqZXU7T3TVi1h4QtQQPgbiZoPjMAdSH33rFW',
				eatImageURI:
					'https://cloudflare-ipfs.com/ipfs/QmcVmS1SCMwVungGD6o4R2ThZ9xVceR2JyLn64iU2WiNJF',
				loseImageURI:
					'https://cloudflare-ipfs.com/ipfs/QmUcQENwb9FH2LGQGRmhri616GArcFMkDYjUJnvqCZnSHw',
				hp: 300,
				attackDamage: 30,
				healAmount: 120,
				criticalChance: 20,
			},
		],
		'Shredder',
		// string memory bossImageURI,
		'https://cloudflare-ipfs.com/ipfs/QmbhPKTyZkbzTcHMTmD94eoXQPFBLBJ6nYL3hPQ3DdpmHB',
		// string memory bossAttackImageURI,
		'https://cloudflare-ipfs.com/ipfs/QmUyhBULoHxgsoSiuTYD6bieyNhHPxNRGknZH5P4SRaf1C',
		// string memory bossEatImageURI,
		'https://cloudflare-ipfs.com/ipfs/QmUVTXNZm2GfEdfve6H9Thr33osBZNo8A8JHtYFWnx2xt2',
		// string memory bossLoseImageURI,
		'https://cloudflare-ipfs.com/ipfs/QmSHq8DSKaTB9jcoFhRknyfVd9zwp7mRtSmccPhNqdzquP',
		// uint bossHp,
		10000,
		// uint bossAttackDamage
		50
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
