// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions


// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

/**
 * @title A sample Raffle contract
 * @author Debsourya Datta
 * @notice This contract is for creating a sample raffle
 * @dev Implements Chainlink VRFv2
 */

contract Raffle is VRFConsumerBaseV2Plus {
    error Raffle__SendMoreToEnterRaffle();
    error Raffle__TranferFailed();
    error Raffle__RaffleNotOpen();
    error Raffle__UpkeepNotNeeded(uint256 balance, uint256 playersLength, uint256 raffleState);

    /* Type Declarations */
    enum RaffleState {
        OPEN, // 0
        CALCULATING // 1
    }

    /* State Variables */
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    uint256 private immutable i_entranceFee;
    // @dev Duration of the lottery in seconds
    uint256 private immutable i_interval;
    bytes32 private immutable i_keyHash;
    uint256 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;
    address private s_recentWinner;
    RaffleState private s_raffleState;

    // bool s_calculatingWinner = false; -> Not a good practice when we have more than 1 state

    // Events
    event RaffleEntered(address indexed player);
    event WinnerPicked(address indexed winner);




    constructor(uint256 entranceFee, uint256 interval, address _vrfCoordinator, bytes32 gasLane, uint256 subscriptionId, uint32 callbackGasLimit) VRFConsumerBaseV2Plus(_vrfCoordinator) { // passing the VRF Coordinator address from our constructor to the VRFConsumerBaseV2Plus constructor
        i_entranceFee = entranceFee;
        i_interval = interval;
        i_keyHash = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;

        s_lastTimeStamp = block.timestamp;
        s_raffleState = RaffleState.OPEN;
    }




    function enterRaffle() external payable {
        // require(msg.value >= i_entranceFee, "Not enough ETH sent");
        if(msg.value < i_entranceFee) {
            revert Raffle__SendMoreToEnterRaffle();
        }
        if(s_raffleState != RaffleState.OPEN){
            revert Raffle__RaffleNotOpen();
        }
        s_players.push(payable(msg.sender));
        // Why use events -> 1. Makes migration easier 2. Makes front-end "indexing" easier
        emit RaffleEntered(msg.sender);
    }



    // When should the winner be picked?
    /**
     * @dev This is the function that the Chainlink nodes will call to see
     * If the lottery is ready to have a winner picked.
     * The following should be true in order for upkeepNeeded to be true:
     * 1. The time interval has passed between raffle runs
     * 2. The lottery is open
     * 3. The contract has ETH (has players)
     * 4. Implicitly, your subscription has LINK
     * @param - ignored
     * @return upkeepNeeded - true is it's time to restart the lottery
     * @return - ignored
     */
    function checkUpkeep(bytes memory /* checkData */)
        public
        view
        returns (bool upkeepNeeded, bytes memory /* performData */)
    {
        bool timeHasPassed = ((block.timestamp - s_lastTimeStamp) >= i_interval);
        bool isOpen = s_raffleState == RaffleState.OPEN;
        bool hasBalance = address(this).balance > 0;
        bool hasPlayers = s_players.length > 0;
        upkeepNeeded = timeHasPassed && isOpen && hasBalance && hasPlayers;
        return (upkeepNeeded, "");
    }





    // 1. Get a random number 2. Use the random number to pick a player 3. Be automatically called
    // pickWinner function
    function performUpkeep(bytes calldata /* performData */) external  {
        // Check to see if enough time has passed
        (bool upkeepNeeded,) = checkUpkeep("");
        if(!upkeepNeeded) {
            revert Raffle__UpkeepNotNeeded(address(this).balance, s_players.length, uint256(s_raffleState));
        }
        s_raffleState = RaffleState.CALCULATING;
        // 1. Request the RNG
        // 2. Get the random number
        VRFV2PlusClient.RandomWordsRequest  memory request = VRFV2PlusClient.RandomWordsRequest({
            keyHash: i_keyHash, // the gas lane, max gas price
            subId: i_subscriptionId,
            requestConfirmations: REQUEST_CONFIRMATIONS, // number of confirmations
            callbackGasLimit: i_callbackGasLimit, // gas limit for the callback
            numWords: NUM_WORDS,
            extraArgs: VRFV2PlusClient._argsToBytes(
                VRFV2PlusClient.ExtraArgsV1({
                    nativePayment: false
                })
            )
        });
        s_vrfCoordinator.requestRandomWords(
           request
        );
    }




    // CEI - Check, Effects, Interactions Pattern
    function fulfillRandomWords(uint256 /* requestId */, uint256[] calldata randomWords) internal override {
        //* Checks

        // s_player = 10
        // rng = 12
        // 12 % 10 = 2
        // 4763947283787878239879849 % 10 = 9

        //* Effects (Internal Contract State)
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        // randomWords will be an array of length 1 since we have set NUM_WORDS to 1
        address payable recentWinner = s_players[indexOfWinner];
        s_recentWinner = recentWinner;

        s_raffleState = RaffleState.OPEN;
        s_players = new address payable[](0);
        s_lastTimeStamp = block.timestamp;
        emit WinnerPicked(recentWinner);

        //* Interactions (External Contract Interactions)
        (bool success,) = recentWinner.call{value: address(this).balance}("");
        if(!success) {
            revert Raffle__TranferFailed();
        }
    }




    // Getter Functions

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }

    function getRaffleState() external view returns (RaffleState) {
        return s_raffleState;
    }

    function getPlayer(uint256 indexOfPlayer) external view returns (address) {
        return s_players[indexOfPlayer];
    }
}
