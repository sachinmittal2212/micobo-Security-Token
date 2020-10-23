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

const HDWalletProvider = require("@truffle/hdwallet-provider")
const { GSNProvider } = require("@openzeppelin/gsn-provider")

// const infuraKey = "fj4jll3k.....";

const fs = require("fs")
const mnemonic = fs.readFileSync(".mnemonic").toString().trim()

module.exports = {
	/**
	 * Networks define how you connect to your ethereum client and let you set the
	 * defaults web3 uses to send transactions. If you don't specify one truffle
	 * will spin up a development blockchain for you on port 9545 when you
	 * run `develop` or `test`. You can ask a truffle command to use a specific
	 * network from the command line, e.g
	 *
	 * $ truffle test --network <network-name>
	 */

	contracts_directory: "./factories",

	networks: {
		// Useful for testing. The `development` name is special - truffle uses it by default
		// if it's defined here and no other network is specified at the command line.
		// You should run a client (like ganache-cli, geth or parity) in a separate terminal
		// tab if you use this network and you must also set the `host`, `port` and `network_id`
		// options below to some value.

		development: {
			provider: () => {
				return new HDWalletProvider(mnemonic, "http://localhost:8545")
			},
			port: 8545,
			network_id: "*",
		},

		rinkeby: {
			provider: () => {
				return new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/v3/303b722ab2ff4afb8b0f8f6a966ab6af")
			},
			network_id: 4,
			gas: 10000000, // 10.000.000
			gasPrice: 3000000000, // 3gwei in wei
			skipDryRun: true,
		},

		// Useful for deploying to a public network.
		// NB: It's important to wrap the provider as a function.
		// ropsten: {
		// provider: () => new HDWalletProvider(mnemonic, `https://ropsten.infura.io/${infuraKey}`),
		// network_id: 3,       // Ropsten's id
		// gas: 5500000,        // Ropsten has a lower block limit than mainnet
		// confirmations: 2,    // # of confs to wait between deployments. (default: 0)
		// timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
		// skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
		// },

		// Useful for private networks
		// private: {
		// provider: () => new HDWalletProvider(mnemonic, `https://network.io`),
		// network_id: 2111,   // This network is yours, in the cloud.
		// production: true    // Treats this network as if it was a public net. (default: false)
		// }
	},

	// Set default mocha options here, use special reporters etc.
	mocha: {
		reporter: "eth-gas-reporter",
		reporterOptions: {
			currency: "EUR",
			gasPrice: 80,
			url: "http://localhost:8545",
		},
	},

	// Configure your compilers
	compilers: {
		solc: {
			// version: "0.5.3", // Version truffle should use, default: truffle's internal version
			docker: false, // Use "0.5.1" you've installed locally with docker (default: false)
			settings: {
				// See the solidity docs for advice about optimization and evmVersion
				optimizer: {
					enabled: true,
					runs: 1024, // 2^10
				},
				evmVersion: "constantinople",
			},
		},
	},

	plugins: ["truffle-security", "solidity-coverage"],
}