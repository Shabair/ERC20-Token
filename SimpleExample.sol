// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

/**
* functionality:
* 1) add balance only by owner
* 2) force transfer only by admin
* 3) individual transfer
* 4) total persons count
* 5) Individual Transfer
*/ 

contract main{
    
    
    struct Person{
        uint balance;
        bool created; //if there no data exits then by default bool retuens false
    }
    
    mapping(address => Person) Persons;
    uint totalAddresses;
    
    address owner;
    
    event balanceAdded(address from, address to, uint amount);
    event TranferByOwner(address _owner, address from, address to, uint amount);
    
    constructor(){
        owner = msg.sender;
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner,"Only Owner Is Allowed");
        _;
    }
    
    function addBalance(address _address,uint _balance)public onlyOwner{
        if(!Persons[_address].created){
            totalAddresses++;
            Persons[_address].created = true;
        }
        Persons[_address].balance += _balance; 
        emit balanceAdded(msg.sender, _address, _balance);
    }
    
    function getBalance(address _address)external view returns(uint){
        return Persons[_address].balance;
    }
    
    error insufficientBalance(uint requested, uint available);
    
    function transder(address from, address to, uint amount)public onlyOwner{
        if(Persons[from].balance < amount){
            revert insufficientBalance({
                requested:amount,
                available:Persons[from].balance
            });
        }
        
        Persons[from].balance -= amount;
        Persons[to].balance += amount;
        emit TranferByOwner(msg.sender, from, to, amount);
    }
    
    function countPersons() public view returns(uint){
        return totalAddresses;
    }
    
    function CheckIfAddressExits(address _address) public view returns(bool){
        return Persons[_address].created;
    }
}