const MicoboSecurityToken = artifacts.require('SecurityToken')
const SecurityTokenPartition = artifacts.require('SecurityTokenPartition')

const truffleAssert = require('truffle-assertions')

const { conf } = require('../token-config')
const { Role } = require('./Constants')

contract('Test Deployment', async (accounts) => {
	let micoboSecurityToken, securityTokenPartition

	// deepEqual compares with '==='

	it('deploys micobo security token', async () => {
		micoboSecurityToken = await MicoboSecurityToken.new(
			conf.name,
			conf.symbol,
			conf.granularity,
			conf.standardCap,
			accounts[0],
			accounts[0],
			accounts[0],
			accounts[0],
			accounts[0]
		)
	})

	it('adds the standard partition', async () => {
		securityTokenPartition = await SecurityTokenPartition.new(
			micoboSecurityToken.address,
			conf.standardPartition
		)

		// add partition
		await micoboSecurityToken.addPartitionProxy(
			conf.standardPartition,
			securityTokenPartition.address
		)

		assert.deepEqual(
			await securityTokenPartition.securityTokenAddress(),
			micoboSecurityToken.address
		)

		assert.deepEqual(
			await securityTokenPartition.partitionId(),
			conf.standardPartition
		)

		assert.deepEqual(
			(await micoboSecurityToken.cap()).toNumber(),
			conf.standardCap
		)

		assert.deepEqual(await micoboSecurityToken.partitionProxies(), [
			securityTokenPartition.address,
		])
	})

	it('Token gives me all the correct token information', async () => {
		assert.deepEqual(await micoboSecurityToken.name(), conf.name)

		assert.deepEqual(await micoboSecurityToken.symbol(), conf.symbol)

		assert.deepEqual(
			(await micoboSecurityToken.granularity()).toNumber(),
			conf.granularity
		)

		// total cap should be equal to standard partition cap at this point
		assert.deepEqual(
			(await micoboSecurityToken.cap()).toNumber(),
			conf.standardCap
		)

		assert.deepEqual((await micoboSecurityToken.totalSupply()).toNumber(), 0)
	})

	it('partition gives me all the correct token information', async () => {
		assert.deepEqual(await securityTokenPartition.name(), conf.name)

		assert.deepEqual(await securityTokenPartition.symbol(), conf.symbol)

		assert.deepEqual((await securityTokenPartition.decimals()).toNumber(), 18)

		assert.deepEqual(
			(await securityTokenPartition.cap()).toNumber(),
			conf.standardCap
		)

		assert.deepEqual((await securityTokenPartition.totalSupply()).toNumber(), 0)
	})
})
