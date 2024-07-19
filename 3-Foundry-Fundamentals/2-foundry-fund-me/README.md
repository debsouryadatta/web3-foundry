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

10. Adding function testPriceFeedVersionIsAccurate() in the FundMeTest.t.sol file, to test the version of the price feed-> Gave error, `forge test -vvv` -> to get more details about the error. `forge test --match-test testPriceFeedVersionIsAccurate -vvv` -> to run only this test.
    
11. We got to know that the error is in the testPriceFeedVersionIsAccurate func, the error is actually because when we run `forge test --match-test testPriceFeedVersionIsAccurate -vvv` -> It runs up a new anvil instance and when the test got ran completely, the anvil instance got destroyed and the price feed version is not available anymore.
    
12. 4 types of testing:
    - Unit: Testing a single function
    - Integration: Testing multiple functions
    - Forked: Testing on a forked network
    - Staging: Testing on a live network (testnet or mainnet)

13. Addressing the previous error, we should use `forge test --match-test testPriceFeedVersionIsAccurate -vvv --fork-url $SEPOLIA_RPC_URL` -> to run the test on a forked network. -> It will run the test on the forked network and the price feed version will be available even after the test is completed hence the error will not occur.
    
14. Downside -> It will create a lot of bill for many tests, so we should not use fork-urls wherever it is not necessary.
    
15. `forge coverage --rpc-url/--fork-url $SEPOLIA_RPC_URL` -> to get the coverage of the tests(No. of lines of code tested).
    
16. Making the priceFeed address modular, sending the Sepolia address for AggregatorV3Interface in the constructor and storing it in another variable.

17. Refactoring the DeployFundMe Contract so that it can be called in the test scripts, changing the testOwnerIsSender func -> msg.sender in place of address(this)

18. Creating a HelperConfig.s.sol file to store the network infos so that we don't have to repeat during development.

19. Refactoring the DeployFundMe.s.sol so that it uses the HelperConfig.s.sol file to get the network infos.

20. Adding getMainnetEthConfig in the HelperConfig.s.sol file, testing it out with the mainnet rpc url `forge test --fork-url $MAINNET_RPC_URL`

21. Mocking the anvil price feed, creating a new file -> MockV3Aggregator.sol, copying it from the github repo, deploying it in the anvilConfig function and using it there.

22. Using constant variables instead of keeping the values hardcoded in the function args.

23. And now that we have the mock anvil price feed, we can test the price feed version without using the forked network. `forge test`

24. Now we can directly run forge coverage without using the forked network. `forge coverage`

25. Writing the testFundFailsWithoutEnoughETH function - To check if the fund function fails when the user doesn't send enough eth.
    
26. Refactoring the FundMe.sol -> storage variables starting with "s_", changing some variables from public to private for more gas efficiency.

27. Creating 2 getter functions -> getAddressToAmountFunded() & getFunder()

28. Writing a new test func testFundUpdatesFundedDataStructure() to test the fund updates in the data structures, using "makeAddr" to create a random address and making TX with this address using vm.prank(This prevents the confusion of msg.sender/address(this) and it only works in the test environment). Proving the dummy USER with some STARTING_BALANCE.

29. `forge coverage` -> Tiny bit better coverage.

- **More Coverage**
30. Writing new test func -> testAddsFunderToArrayOfFunders() to test the adding of funder to the array of funders.

31. Writing new test func -> testOnlyOwnerCanWithdraw() to test if only the owner can withdraw the funds, checking the onlyOwner modifier.

32. Using modifier funded -> best practice to use modifiers to prevent repeating stuff when the tests become large(Suppose we have to test the functions after 18 transactions)

33. Following a strategy to write tests -> Arrange, Act, Assert, writing new test func -> testWithDrawWithASingleFunder() to test the withdraw function with a single funder.

34. Writing new test func -> testWithdrawFromMultipleFunders() to test the withdraw function with multiple funders. Using hoax(prank + deal), startPrank stopPrank, and using uint160 since it is required whenever we arte generating addresses with uint.

35. `forge coverage` -> Now the coverage is lot better than before.

- **Chisel**
36. Chisel -> Solidity in the terminal. Easy way to test out small solidity code snippets.

- **Gas: Cheaper Withdraw**
37.  `forge snapshot --match-test testWithdrawFromMultipleFunders` -> To get the gas cost of the testWithdrawFromMultipleFunders function in the .gas-snapshot file.
    
38. When we are working with anvil, the gas price is set to 0, so to simulate actual gas price we need to tell our test to pretend to use actual gas price which is done by vm.txGasPrice(GAS_PRICE).

39. Using gasleft() func for setting the gasStart and gasEnd variables and finally calculating the gasUsed.

- **Storage**
40. variables -> Storage, dynamic arrays -> Memory/Storage, mapping -> Storage, struct -> Storage, local variables -> Memory, function arguments -> Memory, return values -> Memory, constants -> byte code, immutable -> byte code, strings -> Memory/Storage

41. `forge inspect FundMe storageLayout` -> To get the storage layout of the FundMe contract.

42. `forge script script/DeployFundMe.s.sol --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast` , `cast storage 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0` -> To get the storage layout of the deployed FundMe contract.(We can connect the etherscan to fetch the storage details)

- **Gas: Cheaper Withdraw(Continued)**
43. Checking the opcode gas costs from - https://www.evm.codes/ , using memory variable in the withdraw func of FundMe.sol to reduce the gas cost.

44. Creating new func in FundMeTest.t.sol -> testWithdrawFromMultipleFundersCheaper() to test the cheaper withdraw function and doing `forge snapshot` - checking the gas costs in the .gas-snapshot file. The testWithdrawFromMultipleFundersCheaper() is lot more cheaper than the testWithdrawFromMultipleFunders().

- **Interactions.s.sol**
45. Things left to do:
    - Proper README
    - Integration tests
    - Programmatic verification
    - Push to Github
  
46. Creating a new file Interactions.s.sol to interact with the FundMe Contract using scripts, creating 2 contracts -> FundFundMe(To interact with the Fund func) & WithdrawFundMe(To interact with the withdraw func).

47. Get most recent deployments using a package -> `forge install Cyfrin/foundry-devops --no-commit`

48. In the Interactions.s.sol, creating a fundFundMe func which funds the most recent deployed contract with 0.01 ether. This fundFundMe func is called in the run func of the FundFundMe contract

49. In test folder, unit folder contains the unit tests, integration folder contains the integration tests, and the mocks folder contains the mocks.

50. Creating a new file -> InteractionsTest.t.sol to test the Interactions.s.sol file

51. In the Interactions.s.sol, writing the WithdrawFundMe contract similar to the fundFundMe contract, writing the testUserCanFundInteractions() func in the InteractionsTest.t.sol file, `forge test --match-test testUserCanFundInteractions` -> to run only this test.

52. Now we can call - `forge script script/Interactions.s.sol:FundFundMe --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast` - to interact with the FundMe contract to fund to the latest deployed contract.

53. Doing `forge test` then `forge test --fork-url $SEPOLIA_RPC_URL`

- **Makefile**
53. Things left to do:
    - Proper README ✅
    - Integration tests ✅
        - PIT STOP! How to make running these scripts easier?
    - Programmatic verification
    - Push to Github

54. To run the scripts easily, creating a new file -> Makefile, adding the commands to run the scripts in the makefile.

55. Sign in to etherscan and create a new project, get the API key and add it to the .env file, also add the PRIVATE_KEY of Metamask Acc1 to the .env file

56. We can verify contracts which we needed to do manually earlier, just by adding the ETHERSCAN_API_KEY and doing `make deploy-sepolia`

57. Going through the repo Makefile and copying it to our Makefile

- **Push to Github**
58. Guiding through the process of creating a new repo in Github, adding the remote origin, pushing the code to Github.

- **Recap**
59. Concluding the whole project, the things we have done.