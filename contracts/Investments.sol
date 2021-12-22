// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.2 <0.9.0;

contract Investment{

    uint256 balanceAmount;
    uint256 depositValue;
    uint256 thresholdAmount;
    uint256 returnOnInvestment;
    
    event BalanceChange(uint depositAmount, uint balanceAmount);

    constructor(){
    thresholdAmount = 12;
    returnOnInvestment = 3;
    }
    
    function getWallet()  public view returns (uint256 _balanceAmount, uint256 _depositValue){
        return (_balanceAmount = balanceAmount, _depositValue = depositValue);
    }
    
    function addDepositAmount(uint256 deposit) public{
        depositValue += deposit;
        balanceAmount += deposit;
        
        if(depositValue >= thresholdAmount){
            balanceAmount += returnOnInvestment;
        } 
        emit BalanceChange(depositValue,balanceAmount);
    }
    
    function withdrawAmount(uint256 widthraw) public {
        require(balanceAmount > widthraw, "not enought balance");
        balanceAmount -= widthraw;
        depositValue = 0;

         emit BalanceChange(depositValue,balanceAmount);
    }
    
}