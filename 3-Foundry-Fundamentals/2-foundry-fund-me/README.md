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

### Steps of development

1. Create a new project with `forge init`.
2. `forge test` to run tests.
3. Copying the remix fund me contracts(FundMe.sol & PriceConverter.sol) to the src folder.
   
4. `forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit` -> to install the chainlink contracts, now the chainlink contracts are in the lib folder.
   
5. remappings = ["@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts"] -> in the foundry.toml file.
   
6. import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol"; -> in the PriceConverter.sol file, `forge build` ran successfully.
   
7. NotOwner() -> FundMe__NotOwner() in the FundMe.sol file(nice convention).
   
8. Creating a new test file -> FundMeTest.t.sol, importing console -> with this we can console log anything on the terminal but for that we need to mention -> `forge test -vv`
   
9.  Deployment done by - us -> FundMeTest -> FundMe, so we should compare fundMe.i_owner() with FundMeTest address rather than msg.sender

10. Adding function testPriceFeedVersionIsAccurate() in the FundMeTest.t.sol file, to test the version of the price feed(Not working on my code currently) -> Gave error, `forge test -vvv` -> to get more details about the error. `forge test -m testPriceFeedVersionIsAccurate -vvv` -> to run only this test.
    
11. We got to know that the error is in the testPriceFeedVersionIsAccurate func, the error is actually because when we run `forge test -m testPriceFeedVersionIsAccurate -vvv` -> It runs up a new anvil instance and when the test got ran completely, the anvil instance got destroyed and the price feed version is not available anymore.
    
12. 4 types of testing:
    - Unit: Testing a single function
    - Integration: Testing multiple functions
    - Forked: Testing on a forked network
    - Staging: Testing on a live network (testnet or mainnet)

13. Addressing the previous error, we should use `forge test -m testPriceFeedVersionIsAccurate -vvv --fork-url $SEPOLIA_RPC_URL` -> to run the test on a forked network. -> It will run the test on the forked network and the price feed version will be available even after the test is completed hence the error will not occur.
    
14. Downside -> It will create a lot of bill for many tests, so we should not use fork-urls wherever it is not necessary.