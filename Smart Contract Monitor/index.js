const Moralis = require('moralis').default;
const { EvmChain } = require('@moralisweb3/common-evm-utils');
require("dotenv").config();
const abi = require('./abi.json');


const runApp = async () => {
    await Moralis.start({
        apiKey: process.env.API_KEY
    });

    const chain = EvmChain.BSC;
    const address = '0x137924D7C36816E0DcAF016eB617Cc2C92C05782'
    let functionName = 'latestAnswer';

    const responseP = await Moralis.EvmApi.utils.runContractFunction({
        address,
        functionName,
        abi,
        chain,
    });

    functionName = 'latestTimestamp';
    const responseT = await Moralis.EvmApi.utils.runContractFunction({
        address,
        functionName,
        abi,
        chain,
    });

    const BNBPrice = responseP.toJSON();
    const Timestamp = Date(responseT.toJSON() *1000);
    console.log("The latest BNB Price is: " + BNBPrice, "\nUpdated on: " +Timestamp);
}
runApp();
