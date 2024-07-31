### Step of Development

- **Quick Intro**
1. Cloning the repo and showing the project structure.

- **Set up**
2. forge init

3. Writing some README stuff - About the smart contract, What we want it to do?

4. Creating a new Raffle contract, and creating two initial functions - enterRaffle() and pickWinner() and also creating a constructor to set the entraceFee.

5. Writing a getter function - getEntranceFee() to get the entrance fee.

- **Solidity Contract Layout**
6. Going through the Solidity contract layout(what they recommend)

- **Custom Errors**
7. Creating custom errors instead of using require(). Naming the error as Raffle__NotEnoughEthSent -> to know from which contract the error is coming from.

- **Events**
8. Events - 
   - Events are used to log data, smart contract can't access logs. Events are tied to the contracts. 
   - Instead of looking for change in parameters, we can listen to events. 
   - Transaction happens, event is emitted, we can listen to the event.
   - Frontends, chainlink, oracles, etc can listen to these events and perform actions based on the events.
   - Inside events, indexed parameters = Topics, indexed parameters are much easier to query than the non-indexed parameters.

- **Events in our Raffle.sol**
9. Adding the event - event EnteredRaffle(address indexed player) and emitting it - emit EnteredRaffle(msg.sender);

- **block.timestamp**
10. 1. Get a random number 2. Use the random number to pick a player 3. Be automatically called

11. Creating a new immutable variable i_interval - to set the time interval for the raffle, s_lastTimeStamp - to store the last timestamp when the pickWinner was called.

12. Giving a condition in the pickWinner() function to check if the time interval has passed or not.

- **Chainlink VRF**
13. Chainlink VRF - After creating the subscription, you need to let the subscription know about the contract that you are deploying, and after deployment you need to let the contract know about the subscription. They need to know each other in order to function properly.

14. The way VRF works is - it makes a request to the Oracle network, the oracle network generates the random number, and sends it back to the contract. Do something with the random number as soon as you get it back.

15. Pasting the code from the Chainlink VRF docs for generating random number, forge install smartcontractkit/chainlink-brownie-contracts@1.1.1 --no-commit - to install the Chainlink VRF.

16. Adding a remappings = ['@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts/'] in the foundry.toml

17. Importing the {VRFConsumerBaseV2Plus} from the Chainlink VRF contracts. If we inherit the VRFConsumerBaseV2Plus then we have to use the constructor of the VRFConsumerBaseV2Plus in our constructor.

18. Updating the constructor, passing the VRF Coordinator address from our constructor to the VRFConsumerBaseV2Plus constructor. Now we use the s_vrfCoordinator in the Raffle.sol.

19. Initializing the VRFV2PlusClient.RandomWordsRequest with immutable variables - i_keyHash, i_subscriptionId, i_callbackGasLimit, constants - REQUEST_CONFIRMATIONS, NUM_WORDS. Sending the whole request to the s_vrfCoordinator.requestRandomWords separately.

- **Implementing Chainlink VRF FulFill**
20. Defining the fulfillRandomWords() func as override -> 
    - Abstract contract has both undefined functions and defined functions.
    - The reason chainlink sets this up as abstract contract is because they want you to define the fulfillRandomWords() function in your contract.
    - Working - When we call the pickWinner() function, it sends a request to the oracle network, the oracle network generates the random number, and sends it back to the contract by calling the fulfillRandomWords() function.
    - why internal - because the chainlink VRF actually gonna call the rawFulfillRandomWords which in turn calls the fulfillRandomWords() function.

- **Modulo Operator %**
21. Defining the fulfillRandomWords() func, getting the random number and doing randomWords[0] % s_players.length to get the index of the winner, transfering the balance of the contract to the winner.

- **Enums**
22. bool s_calculatingWinner = false; -> Not a good practice when we have more than 1 state

23. Defining enum RaffleState -> OPEN, CLOSED, creating a new variable of type RaffleState - s_raffleState, and setting the initial state to OPEN in the constructor.

24. Setting the s_raffleState to CALCULATING in the pickWinner() function, and setting it back to OPEN in the fulfillRandomWords() function.

25. Giving a condition in the enterRaffle() function to check if the raffle is open or not.

- **Resetting an Array**
26. After picking of winner is done in the fulfillRandomWords() function, resetting the players array to an empty array, updating the s_lastTimeStamp, emitting a new event - WinnerPicked.

- **Important notes on building**
27. The better way of writing contracts is to write few lines(few functions) of code and test it, since this is a tutorial and many refactoring of code will be done so Patrick is not testing the code after every few lines of code.

- **CEI - Check, Effects, Interactions**
1.  CEI - Check, Effects, Interactions. Sometimes called FREI-PI - Function Requirements, Effects-Interactions Protocol Invariants

2.  Taking the emit event in the fulfillRandomWords() func from bottom to the Effects part

3.  The checks are at the beginning since it is much more gas efficient to revert early than to do a bunch of work and then revert.

- **Chainlink Automation Introduction**

31. Chainlink Automation Introduction - Previously known as chainlink keepers

32. Skipped this video, since I guess it is not necessary for the project.

- **Chainlink Automation Implementing**
33. There are 2 functions in the Chainlink Automation - checkUpkeep() and performUpkeep(). checkUpkeep() is called by the Chainlink network to check if the contract is in good state or not, and performUpkeep() is called by the Chainlink network to perform the upkeep.

34. We will update the pickWinner() func to implement the checkUpkeep() and performUpkeep() functions.

35. bool upkeepNeeded - to check if the upkeep is needed or not, In the checkUpkeep() function, we will check for - timeHasPassed, isOpen, hasBalance, hasPlayers.

36. Changing the pickWinner() function to performUpkeep() function, checking if the upkeepNeeded is true

- **Custom Errors With Parameters**
37. New custom error - error Raffle__UpkeepNotNeeded(uint256 balance, uint256 playersLength, uint256 raffleState) -> adding parameters to the custom error as to give more information about the error.

- **Concept Claration: Chainlink Automation Process**
    - Registration: Providing the address of your contract and specifying which functions you want Chainlink to call, such as checkUpkeep
    - A Chainlink node periodically calls the checkUpkeep function.
    - If checkUpkeep returns true, the Chainlink node then calls performUpkeep to execute the necessary actions.
    - This allows smart contracts to automate tasks based on blockchain conditions without needing an external trigger from a user or developer.
  
- **Mid-Section Recap**
38. Going through the overall code - players enter raffle -> chainlink calls checkUpkeep() -> chainlink calls performUpkeep() -> performUpkeep calls requestRandomWords -> chainlink sends the random number in fulfillRandomWords() -> fulfillRandomWords picks the winner -> and resets the players array.

- **Testing Introduction**
39. -  Write deploy scripts
       - Note, these will not work on zkSync
    - Write tests
       - Local chain
       - Forked testnet
       - Forked mainnet

- **Deploy Scripts**
40. Creating a new deploy script - DeployRaffle, creating a HelperConfig contract to manage the different NetworkConfig.

41. Inside HelperConfig.s.sol - creating a NetworkConfig struct, creating a mapping of chainId => NetworkConfig, creating 3 functions - getSepoliaEthConfig(), getOrCreateAnvilEthConfig(), getConfigByChainId()

- **Deploying Mocks**
42. Importing the mock contract from the @chainlink/contracts, modifying the getOrCreateAnvilEthConfig() fun, creating the vrfCoordinatorMock using the mock contract provided by the chainlink/contracts and then defining the localNetworkConfig.

43. We live in a multi chain world, so most probably you are going to deploy it in a multi chain so it becomes very important to set up the NetworkConfigs of different chains in the HelperConfig.s.sol

- **Finishing the Deploy Script**
44. Creating another function getConfig() in the HelperConfig.s.sol which internally calls the getConfigByChainId() function.

45. Continuing with the deployContract() func in the DeployRaffle.s.sol, taking the helperConfig, deploying the Raffle inside thge broadcast using the config.

- **Testing Setup**
46. Creating a RaffleTest.t.sol where creating a setup function

47. setup() -> Creating a deployer, taking the (raffle, helperConfig) from the deployer.deployContract(), initializing all the variables from the config.

48. Creating a new test func testRaffleInitializesInOpenState() - to test if the raffle initializes in the open state. Then doing `forge build`, `forge test` - it passes.

- **Headers(Optional)**
49. https://github.com/transmissions11/headers -> Package to create beautiful headers right from the terminal

- **A lot of tests**
50. Creating a new test testRaffleRevertsWhenYouDontPayEnough() - to test if the raffle reverts when you don't pay enough. `forge test --mt testRaffleRevertsWhenYouDontPayEnough` - it passes.

51. Creating a new getPlayer() func in the Raffle.sol to get the player by index

52. Creating a new test testRaffleRecordsPlayersWhenTheyEnter() - to test if the raffle records players when they enter. `forge test --mt testRaffleRecordsPlayersWhenTheyEnter` - it fails since we forgot to give the PLAYER some balance. 

53. vm.deal(PLAYER, STARTING_PLAYER_BALANCE) to supply the PLAYER with some balance, then again `forge test --mt testRaffleRecordsPlayersWhenTheyEnter` - it passes.

- **Testing Events**
54.  Creating a new test testEnteringRaffleEmitsEvent() - to test if entering raffle emits an event and also is it same as the player who entered the raffle. `forge test --mt testEnteringRaffleEmitsEvent` - it passes.

- **vm.warp & vm.roll**
55. Creating a new test testDontAllowPlayersToEnterWhileRaffleIsCalculating() - to test if the raffle doesn't allow players to enter while the raffle is calculating. 

56. Using the vm.warp() to move the time forward, then using the vm.roll() to roll the block to next.

57. Call the raffle.performUpkeep() to change the state to calculating, then try to enter the raffle with another prank, it should revert. `forge test --mt testDontAllowPlayersToEnterWhileRaffleIsCalculating` - it fails, error in next video.

- **Create Subscription**
58. After few debugs, we came to know that it is coming from the InvalidConsumer error in the VRFCoordinatorV2_5Mock.sol which is because we haven't created the subscription for the chainlink VRF.

59. We can create a set up where if we see the subscriptionId to be 0, then we can create a new subscription and add a new consumer programmatically so that all of our test can work.

60. Creating an Interactions.s.sol to create a new subscription and add a new consumer programmatically. Going to the openchain.xyz to get the name of the function using its hash that we got in the metamask Hex section.

61. Inside Interactions.s.sol, creating a new function createSubscriptionUsingConfig() - where we get the vrfCoordinator from the HelperConfig, it calls another function createSubscription().

62. Inside createSubscription() - we get the vrfCoordinator, then we call the createSubscription() function using the vrfCoordinator, subscription gets added and we get back the subId.

65. In the DeployRaffle.s.sol, we check if the subscriptionId is 0, then we call the createSubscription() function using the CreateSubscription contract to get the subscriptionId.

- **Create Subscription From the UI**
66.  Creating subcriptionId from the chainlink site `https://vrf.chain.link/sepolia/new`, getting some sepolia testnet Links from the `https://faucets.chain.link/`

67. Going to `https://docs.chain.link/resources/link-token-contracts#sepolia-testnet`, adding the test Links to the wallet.

68. We can fund the subscription using the Link faucet in the ui itself, but we will be doing all these from the scripts.

- **Fund Subscription**
69. Creating a new contract FundSubscription in the Interactions.s.sol to fund the subscription.

70. Adding a new field link in the getSepoliaEthConfig(), for the localNetworkConfig we are going to use mockLink that we copied from the github repo mocks folder.

71. For using the mock contract, `forge install transmissions11/solmate@v6 --no-commit` to install the solmate package, then adding the remappings = ['@solmate/=lib/solmate/src/'] in the foundry.toml

72. Initialising linkToken from the LinkToken mock contract, adding the link parameter to the localNetworkConfig.

73. Writing the fundSubscription() function in the Interactions.s.sol, we are taking 2 separate approaches for localchains and other chains.

74. Testing the fundSubscription()
    - Getting the subscriptionId from the ui and adding it to getSepoliaEthConfig()
    - Adding the SEPOLIA_RPC_URL in the .env from the prev project
    - `cast wallet import myaccount --interactive`, providing the private key
    - `forge script script/Interactions.s.sol:FundSubscription --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast` to fund the subscription 
    - Subscription funded with the 3 LINKs, we can check the balance in the chainlink site.






<!-- Night - 28, 29, 30 -->