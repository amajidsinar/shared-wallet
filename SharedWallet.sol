pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0-beta.0/contracts/ownership/Ownable.sol";


contract SimpleWallet is Ownable{
    
    mapping (address => uint) public user;
    
    function addAllowance(address _id, uint _amount) public onlyOwner {
        user[_id] += _amount;
    }
    
    function reduceAllowance(address _id, uint _amount) public onlyOwner {
        user[_id] -= _amount;
    }
    
    
    function withdrawMoney(address payable _to, uint _amount) public onlyOwner {
        if(!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        _to.transfer(_amount);
    }
    receive () external payable {
    }
}

