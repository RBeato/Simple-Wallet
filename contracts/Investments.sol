// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.2 <0.9.0;

contract Investment{
    uint256 balanceAmount;
    uint256 depositAmount;
    uint256 thresholdAmount;
    uint256 returnOnInvestment;
    
    constructor(){
    balanceAmount = 0;
    depositAmount = 0;
    thresholdAmount = 12;
    returnOnInvestment = 3;
    }
    
    function getBalanceAmount()  public view returns (uint256){
        return balanceAmount;
    }
    
    
    function getDepositAmount() public view returns (uint256){
        return depositAmount;
    }
    
    function addDepositAmount(uint256 amount) public{
        depositAmount = depositAmount + amount;
        
        if(depositAmount >= thresholdAmount){
            balanceAmount += returnOnInvestment;
        }
    }
    
    function withdrawBalance() public {
        balanceAmount = 0;
        depositAmount = 0;
    }
    
}