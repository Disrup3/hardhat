// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {IMockToken} from "./IMocktoken.sol";

contract D3Token is IMockToken, Ownable, ERC20 {
    bool public paused;
    mapping(address => bool) public whitelistedContracts;
    mapping(address => bool) public admins;

    constructor() ERC20("D3", "D3token") {
        paused = false;
    }

    modifier onlyAdmin() {
        require(admins[msg.sender], "caller not admin");
        _;
    }

    modifier notPaused() {
        require(!paused, "contract is paused");
        _;
    }

    function mintTo(address receiver, uint amount) external onlyAdmin {
        _mint(receiver, amount * 1e18);
    }
}
