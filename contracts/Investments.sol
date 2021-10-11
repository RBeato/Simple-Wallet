// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.2 <0.9.0;

contract Investment{


    uint256 balanceAmount;
    uint256 depositValue;
    uint256 thresholdAmount;
    uint256 returnOnInvestment;
    
    event DepositedAmount(uint amount);
    event WidthrawnAmount(uint amount);


    constructor(){
    thresholdAmount = 12;
    returnOnInvestment = 3;
    }
    
    function getBalanceAmount()  public view returns (uint256){
        return balanceAmount;
    }
    
    function getDepositAmount() public view returns (uint256){
        return depositValue;
    }
    
    function addDepositAmount(uint256 deposit) public{
        depositValue += deposit;
        balanceAmount += deposit;
        
        if(depositValue >= thresholdAmount){
            balanceAmount += returnOnInvestment;
        }
        
        emit DepositedAmount(deposit);
    }
    
    function withdrawAmount(uint256 widthraw) public {
        require(balanceAmount > widthraw, "not enought balance");
        balanceAmount -= widthraw;
        depositValue -= widthraw;

        emit WidthrawnAmount(widthraw);
    }
    
}