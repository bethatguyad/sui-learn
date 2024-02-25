// import SuiClient to create a network client and the getFullnodeUrl helper function
import { getFullnodeUrl, SuiClient } from "@mysten/sui.js/client";
import { TransactionBlock } from "@mysten/sui.js/transactions";
import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519";
import { verifyTransactionBlock } from "@mysten/sui.js/verify";
import { fileURLToPath } from "url";

import env from "dotenv";

env.config();

// see Network Interactions with SuiClient for more info on creating clients
const client = new SuiClient({ url: getFullnodeUrl("localnet") });

// let flag = true;
// let objectList = [];
// let cursor
// while (flag) {
// 	const objects = await client.getOwnedObjects({
// 		owner: "0xa40405b0a44c5b06c568823194a51171a77879c3119c0237509e80368387ad7c",
//     cursor
// 	});
// 	flag = objects.hasNextPage;
//   cursor = objects.nextCursor
// 	for (let o of objects.data) {
// 		const object = await client.getObject({
// 			id: o.data.objectId,
// 			options: {
// 				showType: true,
// 				showContent: true,
// 				showDisplay: true,
// 			},
// 		});
//     objectList.push(object)
// 	}
// }
// objectList = objectList.filter(item => {
//   return item.data.type === "0x4484552bbd2f87f83896b6298f2fb26f5e0d8fe3b007e26d81b12fcd990faa82::puppy::Puppy"
// })
//
// console.log('objectList.length: ', objectList.length)
// console.log('objects: ', JSON.stringify(objectList, null, 2))

for (let i = 0; i < 10; i++) {
	const txb = new TransactionBlock();
	// ... add some transactions...

	// sui client call --package 0x4484552bbd2f87f83896b6298f2fb26f5e0d8fe3b007e26d81b12fcd990faa82 --module puppy --function mint --args 0x8eaca0322bda4e0061fdedd883b838a0b
	// a0531e95d22b25c41db1e9baebba7fa "hello" "http://baidu.com"  --gas-budget 10000000
	let a = txb.moveCall({
		arguments: [
			txb.object(
				"0x4f7d9167d7ca85c301770aed9eaf0f9af6cd6a515f9d9135556865447deb3e6a",
			),
			txb.pure.string("bethatguyad"),
			txb.pure.string("https://avatars.githubusercontent.com/u/160697994?s=400&u=d802beaccf8a2c2066a6c81729a850a3ca972927&v=4"),
		],
		target:
			"0xabc61240a9ece2d963f1eac9f929d0b97c815159d00e8b83e3b76ccbd4cd9afd::puppy::mint",
	});
	//
	// console.log("a: ", a);
	//
	txb.setSenderIfNotSet(
		"0xa40405b0a44c5b06c568823194a51171a77879c3119c0237509e80368387ad7c",
	);

	//
	txb.setGasBudget(10000000);
	const bytes = await txb.build({ client });
	//
	// //
	const keypair = Ed25519Keypair.deriveKeypair(process.env.SEED);
	//
	const { signature } = await keypair.signTransactionBlock(bytes);
	// // if you have a public key, you can verify it
	// //   const isValid = await publicKey.verifyTransactionBlock(bytes, signature);
	// // or get the public key from the transaction block
	const publicKey = await verifyTransactionBlock(bytes, signature);
	// console.log("addr: ", publicKey.toSuiAddress());
	//
	const res = await client.executeTransactionBlock({
		signature: signature,
		transactionBlock: bytes,
		options: {
			// showEvents: true,
			// showEffects: true,
			// showBalanceChanges: true,
			// showInput: true,
			// showRawInput: true,
			// showObjectChanges: true,
		},
	});
	console.log("res: ", res);
	//
}
//
//
