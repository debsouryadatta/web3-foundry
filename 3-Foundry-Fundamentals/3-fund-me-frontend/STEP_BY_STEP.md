### Steps of development

- **Makefile**
1. git clone git@github.com:Cyfrin/html-fund-me-cu.git

- **How Metamask works with your browser**
2. Connecting to the metamask wallet

3. Clicking the getBalance button -> Calling the getBalance() function, using ethers.js to get the balance of the contract using wallet's RPC URL

4. Running `make deploy` in the previous repo to deploy the contract to the local blockchain

5. Connecting to Anvil network -> `anvil` in the previous repo to start the local blockchain
   
6. Creating a new network in metamask -> Anvil, providing the RPC URL - http://127.0.0.1:8545, chain ID - 31337, and currency symbol - ETH

7. Account 4 -> Copying the private key from anvil and importing it to metamask as account 4

8. Going through the fund function in the index.js

- **Introduction to function selectors**
9. The solidity functions are broken down into low level byte code -> function selectors

10. What metamask does is it converts the solidity function into a function selectors

11. `cast sig "fund()"` -> `0xb60d4288` we can see the function selector for the fund function, we can check if the function selector showing in the metamask for the fund function is the same as the one we have with `cast sig "fund()"`

12. To get each parameter of the function, we can use the `cast --calldata-decode "fund()" 0xb60d4288` command

13. We can call the withdraw function with only the account 4 since it is the owner of the contract

- **Recap**
14. Basically wallets injects objects into the window object of the browser, and we can use these objects to interact with the blockchain

15. We can use ethers.js to get the rpc URL of the wallet and get access to an account of the wallet to interact with the blockchain

16. We can learn more about connecting the frontend to the blockchain(in js, react, nextjs with different providers) by checking out the yt video - https://www.youtube.com/watch?v=pdsYCkUWrgQ