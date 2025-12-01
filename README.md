Description

KipuBank is a smart contract that simulates a custodial bank on Ethereum. Users can securely deposit and withdraw ETH, with limits set per transaction and a maximum capital cap.

Features

    ETH deposit with zero validation.
    Withdrawals limited to 1 ETH per transaction.
    Individual balance control per user.
    Total bank capital limit: 1000 ETH.
    Use of custom errors and events for traceability.
    Query functions: balance per user and global statistics.


How to Deploy the Contract

In Remix IDE (Recommended for beginners)

Go to Remix IDE Create a new file called KipuBank.sol and paste the contract code. Go to the “Solidity Compiler” tab. Select version: ^0.8.24. Click Compile KipuBank.sol. 
Go to the “Deploy & Run Transactions” tab. Select: Injected Provider - MetaMask for real networks. Click Deploy. - How to Interact with the Contract

After deployment, you can use the following functions:

deposit() - Deposits ETH into the user's vault. Use the “Value” field in Remix.

withdraw(uint256 amount) - Withdraws ETH, up to the allowed limit (maximum 1 ether).

getBalance(address user) - Returns the user's stored balance (in wei).

getStats() - Returns global statistics: number of deposits and withdrawals.


🧪 Step-by-Step Example

    Initial deposit Function: deposit() Value field: 1 ETH Click transact

    Check balance Function: getBalance() Expected result: 1000000000000000000

    Withdraw part of the balance Function: withdraw(500000000000000000) This withdraws 0.5 ETH

    Check balance again Should display: 500000000000000000
    

⚠️ Custom Errors

The contract sends clear messages if conditions are not met:


contract address	0xDC7ce1653191a2056040425Ff02EBA6894360D90

Sourcify verification successful.
https://repo.sourcify.dev/11155111/0xDC7ce1653191a2056040425Ff02EBA6894360D90/
Blockscout verification successful.
https://eth-sepolia.blockscout.com/address/0xDC7ce1653191a2056040425Ff02EBA6894360D90?tab=contract
Routescan verification successful.
https://testnet.routescan.io/address/0xDC7ce1653191a2056040425Ff02EBA6894360D90/contract/11155111/code

