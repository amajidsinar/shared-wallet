pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0-beta.0/contracts/ownership/Ownable.sol";


contract SimpleWallet is Ownable{
    mapping (address => uint) public user;
    
    event ChangeAllowance(address indexed _dest, address indexed _src, uint oldAmount, uint newAmount);
    event SendMoney(address indexed _dest, uint _amount);
    event ReceiveMoney(address indexed _src, uint _amount);
    
    
    function addAllowance(address _id, uint _amount) public onlyOwner {
        emit ChangeAllowance(_id, msg.sender, user[_id], _amount);
        require(_amount <= address(this).balance, "NOT ENOUGH FUNDS IN THE SMART CONTRACT");
        user[_id] = _amount;
    }
    
    
    
    modifier authorizedSubjects(uint _amount){
        require (isOwner() || user[msg.sender] >= _amount, "YOU ARE NOT ALLOWED");
        _;
    }
    
    function reduceAllowance(address _id, uint _amount) public authorizedSubjects(_amount) {
        emit ChangeAllowance(_id, msg.sender, user[_id], user[_id]- _amount);
        user[_id] -= _amount;
    }
    
    
    function withdrawMoney(address payable _to, uint _amount) public authorizedSubjects(_amount) {
        if(!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit SendMoney(_to, _amount);
        _to.transfer(_amount);
    }
    
    receive () external payable {
        emit ReceiveMoney(msg.sender, msg.value);
    }

}

