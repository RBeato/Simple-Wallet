// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.2 <0.9.0;

contract Investment {
    uint256 balanceAmount;
    uint256 depositValue;
    uint256 thresholdAmount;
    uint256 returnOnInvestment;

    event BalanceChange(uint256 depositAmount, uint256 balanceAmount);

    constructor() {
        thresholdAmount = 12; // set the limit deposit to earn return
        returnOnInvestment = 3;
    }

    function getWallet()
        public
        view
        returns (
            uint256 _balanceAmount,
            uint256 _depositValue // getter for the wallet state
        )
    {
        return (_balanceAmount = balanceAmount, _depositValue = depositValue);
    }

    function addDepositAmount(uint256 deposit) public {
        depositValue += deposit; // increase deposit
        balanceAmount += deposit; // decrease deposit

        if (depositValue >= thresholdAmount) {
            // check if will have return
            balanceAmount += returnOnInvestment;
        }
        emit BalanceChange(depositValue, balanceAmount); // emit event
    }

    function withdrawAmount(uint256 withdraw) public {
        require(balanceAmount > withdraw, "not enough balance"); // check if there is enough
        balanceAmount -= withdraw; // deduce the withdraw amount from the balance
        depositValue -= withdraw; // deduce the withdraw amount from the deposited value

        emit BalanceChange(depositValue, balanceAmount); // emit event
    }
}
