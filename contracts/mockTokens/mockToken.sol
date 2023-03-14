//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// CHALLENGE APUESTAS CON TOKEN ERC20:
// - hacer contrato mocktoken que mintee al msg sender 100 tokens y tenga una funcion publica que mintee 100 tokens a quien la llama
// - implementar en el contrato de apuestas la lógica necesaria para permitir apuestas con token ERC20
// - declarar interfaz IERC20
// - declarar variable del contrato del token que utilizaremos y setear en el constructor
// - implementar lógica en las funciones necesarias para transferir y enviar tokens desde el contrato
// - testear y comprobar que funciona

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 supply
    ) ERC20(_name, _symbol) {
        _mint(msg.sender, supply * 10 ** decimals()); // El "" significa elevado a
    }

    function mint() public {
        _mint(msg.sender, 100 * 10 ** decimals()); // Al mintear, se reciben 100 tokens
    }
}
