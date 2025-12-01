// SPDX-License-Identifier: GPL-3.0
pragma solidity  ^0.8.24;

contract KipuBank {

    // -> Immutable || Constant <-

    // @notice withdrawal limite per transaction  1 ETH
    uint256 public immutable withdrawal_Limit = 1 ether;

    // @notice maximum bank capital - deployment in 1000 ETH to WEI
    uint256 public constant bank_Cap =1000 ether;
    
    // -> Mapping <-
    // @notice  Declaration of a mapping associated with addresses with balance per user (stored in wei)
    mapping (address => uint256 ) private _balances;

     // -> Storage Variables <-

    // total deposits made
    uint256 public totalDeposits;

    // total withdrawals made
    uint256 public totalWithdrawals;

    // -> Custom errors <-

    // Error when withdrawing exceeds the permitted limit
    error WithdrawalExceedsLimit(uint256 requested, uint256 limit);

    // Error when there is insufficient balance to withdraw
    error InsufficientBalance(uint256 available, uint256 requested);

    // Error when deposit exceeds the bank's allowed limit
    error DepositExceedCap(uint256 currentTotal, uint256 requested,uint256 cap);
    
    // Error when attempting to withdraw without funds
    error NoBalanceToWithdraw();

    // Error when transfer fails
    error TransferFailed();

    // -> Events <-

     // When the user deposits ETH
    event Deposit (address indexed user, uint256 amountInWei);

    event Withdrawal(address indexed user, uint256 amountInWei);

    // -> Modifier <-

     // @notice As long as the amount to be deposited is greater than zero
    modifier nonZeroValue (){
        require(msg.value > 0,"You must deposit an amount greater than zero");
        _;
    }

    // -> Functions <-

    // @notice The user deposits ETH in their personal vault and it is sent by (msg.value) 
    function deposit() external payable nonZeroValue {
        uint256 newTotal = address (this).balance;
            if(newTotal > bank_Cap){//If the new balance exceeds the bank limit 
            revert DepositExceedCap ({
                currentTotal: newTotal - msg.value,//the new contract balance
                requested : msg.value,   //value sent by the user
                cap : bank_Cap
                }) ;//revert with the revert keyword, which allows us to throw a custom error 
            }

            _balances[msg.sender] += msg.value ;
            totalDeposits++;     
        emit Deposit(msg.sender, msg.value);  //issue deposit event with user and amount in wei
    }


    //The user withdraws ETH to their vault account, which is sent by (amount)
    function withdraw(uint256 amount) external {
         // Get the user's balance from the mapping _balances
        uint256 userBalance = _balances[msg.sender];

        // Verify that the user has no funds in their vault
        if(userBalance == 0){
            //Reverses error when attempting to withdraw without funds
            revert NoBalanceToWithdraw() ;
        }
        // Check whether the requested amount exceeds the limit allowed per transaction  
        if(amount > withdrawal_Limit){  
            // Reverse with custom error including the request and the limit
            revert WithdrawalExceedsLimit({  
                requested: amount, 
                limit : withdrawal_Limit
                });
        }
        // Verify that the user has sufficient balance to withdraw the desired amount
        if (amount > userBalance) {  
            // Reverse with a custom error indicating how much is available and how much was requested
            revert InsufficientBalance({
                available: userBalance,
                requested: amount
            });
        }
        // Execute the withdrawal
        executeWithdrawal(msg.sender, amount);
    } 


    // @notice Execute the transfer of ETH to the user and update the internal status
     function executeWithdrawal ( address user, uint256 amount)private{

        // Reduce the user's internal balance
        _balances[user] -= amount;
         // Increase the total number of withdrawals
        totalWithdrawals++;

         // Perform the secure transfer of ETH to the user using call
        (bool success,) = payable(user).call{value:amount}("");

          // Verify that the transfer was successful
       if (!success) revert TransferFailed(); // ← Error personalized

        // Issue an event indicating that the withdrawal has been completed
        emit Withdrawal(user, amount);
     } 

    // @notice Check a user's current balance
     function getBalance(address user) external view returns (uint256) {
        return _balances[user]; //return a user's balance via the mapping balances
     }

     // @notice Returns bank statistics
    function getStats() external view returns (uint256 deposits, uint256 Withdrawals){
        return (totalDeposits , totalWithdrawals);
    }
}
