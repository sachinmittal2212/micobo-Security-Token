const truffleAssert = require('truffle-assertions')

const conf = require('../token-config')

const {deployAllContracts, Role, Code} = require('./deployment.js');


contract('Test Off-Chain Validation', async (accounts) => {

    // TODO
    
	let contracts

	// deepEqual compares with '==='

	before(async () => {

		contracts = await deployAllContracts(accounts)

	})

})