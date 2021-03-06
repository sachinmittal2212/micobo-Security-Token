const SecurityToken = artifacts.require("SecurityToken")
const securityTokenJSON = require("../build/contracts/SecurityToken.json")

module.exports = async (deployer, network, accounts) => {
	if (network == "development" || network == "soliditycoverage" || network == "test") {
		console.log("skipping role granting")
		return
	}

	try {
		let st = await SecurityToken.deployed()

		// add whitelist editor for account 0
		await st.addRole("0x57484954454c4953545f454449544f5200000000000000000000000000000000", accounts[0])

		// add whitelist editor for elements backend
		await st.addRole(
			"0x57484954454c4953545f454449544f5200000000000000000000000000000000",
			"0xe375639d0Fa6feC13e6F00A09A3D3BAcf18A354F" // account[1] and static backend signer
		)

		// add timelock editor for elements backend
		await st.addRole(
			"0x54494d455f4c4f434b5f454449544f5200000000000000000000000000000000",
			"0xe375639d0Fa6feC13e6F00A09A3D3BAcf18A354F"
		)

		// add controller for elements backend
		await st.addRole(
			"0x434f4e54524f4c4c455200000000000000000000000000000000000000000000",
			"0xe375639d0Fa6feC13e6F00A09A3D3BAcf18A354F"
		)

		// add redeemer for elements backend
		await st.addRole(
			"0x52454445454d4552000000000000000000000000000000000000000000000000",
			"0xe375639d0Fa6feC13e6F00A09A3D3BAcf18A354F"
		)

		// add issuer for elements backend
		await st.addRole(
			"0x4953535545520000000000000000000000000000000000000000000000000000",
			"0xe375639d0Fa6feC13e6F00A09A3D3BAcf18A354F"
		)
	} catch (e) {
		throw e
	}
}
