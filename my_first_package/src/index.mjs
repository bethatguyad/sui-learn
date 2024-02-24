// import SuiClient to create a network client and the getFullnodeUrl helper function
import { getFullnodeUrl, SuiClient } from "@mysten/sui.js/client";
import { TransactionBlock } from "@mysten/sui.js/transactions";
import { Ed25519Keypair } from "@mysten/sui.js/keypairs/ed25519";
import { verifyTransactionBlock } from "@mysten/sui.js/verify";

// see Network Interactions with SuiClient for more info on creating clients
const client = new SuiClient({ url: getFullnodeUrl("localnet") });
const txb = new TransactionBlock();
// ... add some transactions...

let a = txb.moveCall({
	arguments: [txb.pure.u64(100), txb.pure.u64(20)],
	target:
		"0xab4573a5d4b0e561c55132ddf2c90255b7ab1ef7c3fa2d9f83b0e5e6892204da::calc::add",
});

console.log("a: ", a);

txb.setSenderIfNotSet(
	"0xa40405b0a44c5b06c568823194a51171a77879c3119c0237509e80368387ad7c",
);
txb.setGasBudget(10000000);
const bytes = await txb.build({ client });

//
const keypair = Ed25519Keypair.deriveKeypair(
	"tool doll catalog moon bless antenna act skull ugly honey stone vibrant",
);

const { signature } = await keypair.signTransactionBlock(bytes);

// if you have a public key, you can verify it
//   const isValid = await publicKey.verifyTransactionBlock(bytes, signature);
// or get the public key from the transaction block
const publicKey = await verifyTransactionBlock(bytes, signature);
console.log("addr: ", publicKey.toSuiAddress());

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

// let unsub = await client.subscribeEvent({
// 	filter: {
// 		Package:
// 			"0xab4573a5d4b0e561c55132ddf2c90255b7ab1ef7c3fa2d9f83b0e5e6892204da",
// 		MoveModule: "calc",
// 	},
//   onMessage: (e) => {
//     console.log('e: ', e)
//     unsub()
//   },
// });

console.log("res: ", JSON.stringify(res, null, 2));

