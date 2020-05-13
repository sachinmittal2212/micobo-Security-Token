# micobo Security Token


## Setup

1. Solidity  

we use `solc` binary, for manual compilation, since `solcjs` npm module throws  error ("File import callback not supported")

[Install the binary here](https://solidity.readthedocs.io/en/latest/installing-solidity.html)  
look for the brew installation

2. Truffle

You need truffle installed globally

### Compatibility

We implement ERC1400Partition.  
We implement ERC20 with default partitions.  
We implement ERC20 as proxies for specific partitions.  

We don't implement operator and transfer functionality of ERC1400Raw.  
We don't implement ERC777.  

#
## Tests

All functionality of the smart contracts is tested in mulitple test classes found in the `/test` folder.  

The tests are kept as atomic (specific) and autonomous as possible.  
Autonomy means that no test will fail or succeed dependant on the outcome of a different test.

- Make sure the **solidity version** in `truffle-config.js` is the same as your contracts' pragma statement!


- Also make sure that **Ganache** is running on port `:8545`

- **GSN_Relayer**: If you test GSN functionality, also run the dev-relayer:
    ```
    npx oz-gsn run-relayer --ethereumNodeURL http://localhost:8545
    ```

Use the test script to run all tests:

    npm run test

#

## Gas report

Gas report is configured by default in `truffle-config.js`  

It can be configured here:

    mocha: {
            reporter: 'eth-gas-reporter',
            reporterOptions: {
                currency: 'EUR',
                gasPrice: 2,
                url: 'http://localhost:8545',
            },
        },
    }

#
## Code Coverage

Stop you local blockchain and start the coverage plugin with: 

    truffle run coverage --temp /build/solcover --network development

_(also run the GSN relayer if you don't want GSN tests to fail)_  

For specific files, add 

    --file="test/10_spendingLimitTests.js"


[solidity-coverage package on npm](https://www.npmjs.com/package/solidity-coverage#config-options)

#
## Deployment

Edit the ``token-config.json`` file to set token **name**, **symbol** and **cap** etc.

Use the deploy script to deploy all contracts on local testnet (localhost:8454):

    npm run deploy

#
## Architecture

![architecture](./resources/security_token.png "Architecture")

#



#### Constrainable.sol

Constraint Modules can be set to implement any kind of on-chain checks.

#
#### Administrable.sol



#
## Gas Consumption

TODO

#  
#### Diagrams

All diagrams were made with the free software [draw.io](draw.io)  
Simply open the corresponding XML file in the editor and export into JPEG to update any diagram.



#
# Explanations

## Admin

Admin is a role.
It controls assignment and removal of all roles.  
It can also assign and remove other admins.  
It cannot renounce itself, as this would leave the contract potentially without admin.

## Controller

Controllers is a role.
As every role, it can be assigned or removed by the admin role, as well as renounce itself.  
If the contract is `isControllable()`,  
Controllers can force-transfer tokens disregarding ownership and constraints using `operatorTransferByPartition`.  
In this case, the controller is regarded as a kind of master-operator.

## Operator

Operators can transfer tokens on behalf of users that authorized them to do so using `operatorTransferByPartition`.  
Users can authorize addresses to transfer tokens on their behalf on a "by partition"-basis.  
This authorization can be revoked at any time.

