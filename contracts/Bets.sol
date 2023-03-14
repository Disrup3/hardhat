//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./Ownable.sol";

interface IMockToken {
    function totalSupply() external;

    function balanceOf(address user) external;

    function allowance(address owner, address spender) external;

    function approve(address spender, uint256 amount) external; // allow()

    function transfer(address to, uint256 amount) external;

    function transferFrom(address from, address to, uint256 amount) external;
}

struct Game {
    uint256[2] bet;
    uint256 finish_timestamp;
    uint8 winner;
}

contract Bets is Ownable {
    IMockToken mockToken;
    Game[] public games;
    mapping(uint256 => mapping(address => uint256[2])) public userBets; // gameId => wallet => bet
    mapping(address => bool) public isAdmin;
    mapping(address => bool) public isRegistered;

    function _hasFinished(uint256 gameId) private view returns (bool) {
        if (block.timestamp >= games[gameId].finish_timestamp) return true;
        return false;
    }

    modifier hasFinished(uint256 gameId) {
        require(_hasFinished(gameId) == true, "game hasn't finished");
        _;
    }

    constructor(IMockToken token) {
        owner = tx.origin;
        isAdmin[msg.sender] = true;
        mockToken = token;
    }

    function addAdmin(address wallet) public override onlyOwner {
        require(isAdmin[wallet] == false, "Already admin");
        isAdmin[wallet] = true;
    }

    function removeAdmin(address wallet) public override onlyOwner {
        require(isAdmin[wallet] == true, "Not admin");
        require(wallet != msg.sender, "Cannot remove yourself");
        isAdmin[wallet] = false;
    }

    function transferOwnership(address wallet) public override onlyOwner {
        require(wallet != address(0), "Cannot transfer ownership to null");
        owner = wallet;
    }

    function createGame(uint256 h, uint256 m, uint256 s) public onlyOwner {
        Game memory game;
        game.finish_timestamp =
            block.timestamp +
            h *
            1 hours +
            m *
            1 minutes +
            s *
            1 seconds;
        games.push(game);
    }

    function setWinner(
        uint256 gameId,
        uint8 option
    ) public onlyAdmin hasFinished(gameId) {
        Game storage game = games[gameId];
        require(0 < option && option < 3, "Invalid option");
        game.winner = option;
    }

    function bet(uint256 gameId, uint8 option, uint256 amount) public {
        require(_hasFinished(gameId) == false);
        require(0 < option && option < 3, "Invalid option");

        mockToken.transferFrom(msg.sender, address(this), amount);

        userBets[gameId][msg.sender][option - 1] += amount;
        games[gameId].bet[option - 1] += amount;
    }

    function claimReward(uint256 gameId) public hasFinished(gameId) {
        Game storage game = games[gameId];

        uint8 winnerId = game.winner - 1;
        uint256 bettedAmount = userBets[gameId][msg.sender][winnerId];
        uint256 totalAmount = game.bet[0] + game.bet[1];

        uint256 owedAmount = (totalAmount * bettedAmount) / game.bet[winnerId];
        require(owedAmount > 0, "Nothing is owned to you");

        mockToken.transfer(owner, owedAmount / 10);
        mockToken.transfer(msg.sender, (owedAmount * 9) / 10);

        // Actualizamos el valor de la apuesta a 0
        userBets[gameId][msg.sender][winnerId] = 0;
    }

    receive() external payable {}
}
