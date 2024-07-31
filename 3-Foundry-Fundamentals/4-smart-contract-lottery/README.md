# Proveably Random Raffle Contracts

## About

This code is to create a proveably random smart contract lottery.

### What we want it to do?

1. Users can enter by paying for a ticket.
   - The ticket fees are going to go to the winner during the draw
2. After X period of time, the lottery will automatically draw a winner.
   - And thid will be done programmaticaly.
3. Using Chainlink VRF & Chainlink Automation
   - Chainlink VRF - Randomness
   - Chainlink Automation - Time based trigger

### Tests!

1. Write deploy scripts
   - Note, these will not work on zkSync
2. Write tests
   - Local chain
   - Forked testnet
   - Forked mainnet