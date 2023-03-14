//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ownable {
    address public owner;
    mapping(address => bool) admins;

    event Owner_change(address newOwner);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    modifier onlyAdmin() {
        require(
            admins[msg.sender] == true || msg.sender == owner,
            "You are not the owner or an admin"
        );
        _;
    }

    function transferOwnership(address _newOwner) external virtual onlyOwner {
        require(_newOwner != address(0), "Invalid new owner");
        require(_newOwner != address(this), "Invalid new owner");
        emit Owner_change(_newOwner);
    }

    function addAdmin(address _newAdmin) public virtual onlyAdmin {
        require(_newAdmin != address(0), "Invalid new owner");
        require(_newAdmin != address(this), "Invalid new owner");
        require(_newAdmin == owner, "The owner already has admin privileges");
        require(admins[_newAdmin] = false, "This user is already an admin");
        admins[_newAdmin] = true;
    }

    function removeAdmin(address _oldAdmin) public virtual onlyAdmin {
        require(_oldAdmin != address(0), "Invalid new owner");
        require(_oldAdmin != address(this), "Invalid new owner");
        require(admins[_oldAdmin] == true, "This user is already not-admin");
        require(
            _oldAdmin == owner,
            "You can't remove admin privileges to the owner"
        );
        admins[_oldAdmin] = false;
    }
}
