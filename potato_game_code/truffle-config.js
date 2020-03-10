/**
 * Use this file to configure your truffle project. It's seeded with some
 * common settings for different networks and features like migrations,
 * compilation and testing. Uncomment the ones you need or modify
 * them to suit your project as necessary.
 *
 * More information about configuration can be found at:
 *
 * truffleframework.com/docs/advanced/configuration
 *
 * To deploy via Infura you'll need a wallet provider (like truffle-hdwallet-provider)
 * to sign your transactions before they're sent to a remote public node. Infura API
 * keys are available for free at: infura.io/register
 *
 * You'll also need a mnemonic - the twelve word phrase the wallet uses to generate
 * public/private key pairs. If you're publishing your code to GitHub make sure you load this
 * phrase from a file you've .gitignored so it doesn't accidentally become public.
 *
 */

// const HDWallet = require('truffle-hdwallet-provider');
// const infuraKey = "fj4jll3k.....";
//
// const fs = require('fs');
// const mnemonic = fs.readFileSync(".secret").toString().trim();
const HDWalletProvider = require("truffle-hdwallet-provider");

var MNENOMIC = "someone success life suggest gorilla oak cruel eagle check session fatal kind";
//var MNENOMIC = "list loyal bracket card sample hill siege alien adapt chronic rescue canvas";
var APIKEY = "2edbdd953f714eeab3f0001bb0b96b91"

module.exports = {
  compilers: {
     solc: {
       version: "0.6.0"
     }
  },
  networks: {
    development: {
      host: "127.0.0.1",
      //port: 9545, // for truffle develop
      port: 8545, // for ganache-cli
      network_id: "*", // Match any network id
    },
    ropsten: {
      provider: () =>
        new HDWalletProvider(MNENOMIC, "https://ropsten.infura.io/v3/" + APIKEY),
      network_id: '3',
    },
    // main ethereum network(mainnet)
    main: {
      provider: () => new HDWalletProvider(MNENOMIC, "https://mainnet.infura.io/v3/" + APIKEY),
      network_id: 1,
      gas: 3000000,
      gasPrice: 10000000000
    },

    // settings for truffle develop
    // the gas limit thing doesn't seem to work so just use ganache..
    /*
    develop: {
      port: 8545,
      network_id: 20,
      gasLimit: 200000000,
      default_balance_ether: 1000000000000000, // $$$$
    }*/
  }
};
