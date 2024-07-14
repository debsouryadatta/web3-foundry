## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

## Steps of dev

### Foundry Installation:
1. curl -L https://foundry.paradigm.xyz | bash
2. source /home/debsourya/.bashrc
3. foundryup

1. src -> For the main smart contracts, test -> For testing the smart contracts in the src, scripts -> For interacting with the smart contracts that are in src
2. import code from SimpleStorage.sol. anvil, ganache -> to try out the smart contract on local blockchains
3. Add Ganache localhost to the network in metamask, add the private key of the account in metamask
4. RPC Url - It is the url of the blockchain network that we are sending request to(In this case Ganache localhost)
5. With foundry forge we don't need to write raw http requests to interact with the smart contract
6. forge create SimpleStorage --rpc-url http://localhost:7545 --interactive -> To deploy the smart contract

- "I promise to never use my private key associated with the real money in plain text!!"

7. Deploy the smart contracts using scripts, writing the script in solidity(There are some cheat codes which only work on foundry), forge script script/DeploySimpleStorage.s.sol(naming convention for scripts) --rpc-url http://localhost:7545 --broadcast --private-key 0xff831bf3f838e294c6a2492480b2fde29dea9af8da07111ca1628dc2dc44b48e

8. "cast --to-base 0x714c2 dec" (Converting hex value to decimal)
9. Inside run-latest.json file, we can see the tansaction block which is sent to the blockchain. The broadcast folder contains the files which has details of the deployed contracts.
10. We need the private key to sign the transaction, so that the transaction is sent to the blockchain(Contract deployments are also kind of transactions)

11. For interaction with the smart contract, there are 2 ways:
    - Using the script
    - Using the command
    - In this project we will be using the command
12. Adding PRIVATE_KEY and the RPC_URL to the .env file, source .env -> To use the environment variables. For now we will be using Private keys from .env file, however it is not a good practice. We should instead use key stores encrypted with passwords for using our private keys or deploy with platforms like thirdweb

13. Updated Script - forge script script/DeploySimpleStorage.s.sol --rpc-url $RPC_URL --broadcast --private-key $PRIVATE_KEY

14. Deploying to ThirdWeb -> npx thirdweb deploy (It will first install the thirdweb), link the metamask account to the thirdweb, then deploy the contract (Will do it later**)

15. For interacting with the smart contract with the cli, we will be using the cast command, cast send {address} {function} {args} --rpc-url $RPC_URL --private-key $PRIVATE_KEY
16. Updated script - cast send 0xf76a2813d174E4744ae3b279767A841c596bEeDA "store(uint256)" 122 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
17. cast call 0xf76a2813d174E4744ae3b279767A841c596bEeDA "retrieve()" --rpc-url $RPC_URL
18. send -> To call non view functions in the smart contract, call -> To call view functions in the smart contract

- Deploying to testnet/mainnet(Not local blockchains)
19. Signing in to Alchemy, creating a new project, getting the SEPOLIA_RPC_URL and adding it to the .env file
20. Take the private key of any of the metamask account and add it to the .env file as PRIVATE_KEY
21. forge script script/DeploySimpleStorage.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast -> To deploy the smart contract to the testnet, we can view it on the alchemy dashboard as well as on etherscan sepolia testnet.

22. Verifying the contract on etherscan manually, before verification - the smart contract will be visible on etherscan as bytecode, after verification - the smart contract will be visible on etherscan


- Concept claration:
    - Deployment can be done: 1. Using cli✅ 2. Using scripts✅
    - Interaction can be done: 1. Using cli✅ 2. Using scripts
    - Contract verification can be done: 1. Manually on etherscan✅ 2. Using scripts

23.   Use forge fmt -> To format the solidity code


- Concept Claration:
    - Node - Nodes are computers that participate in the blockchain network.
    - You can run your own node or use a service provider like Infura, Alchemy, or QuickNode.
    - These providers run full nodes and allow you to connect to them via their API.

- Concept Claration:
    - forge - compile, test, and deploy smart contracts
    - cast - interact with smart contracts
    - anvil - run a local Ethereum node/blockchain(similar to ganache)