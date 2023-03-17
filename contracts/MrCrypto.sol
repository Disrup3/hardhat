// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MrCrypto is ERC721Enumerable {
    using Strings for uint256;
    // supply max de 10000 tokens
    // funcion de minteo
    // minteo con token nativo de la red
    // whitelis para mintear
    // modificadores de acceso
    // logica de retornar url de json
    // funcion de withdraw

    uint16 public constant MAX_SUPPLY = 10000; // es eficiente usar uint256 para esta variable?
    uint8 public immutable MAX_PER_USER;
    uint public constant COST_PER_NFT = 1 ether;
    bool public whitelistOn = true;
    bool public paused = false;
    bool revealed = false;

    mapping(address => bool) public isWhitelisted;
    mapping(address => uint) public userMints;
    mapping(address => bool) isAdmin;

    modifier onlyAdmin() {
        require(isAdmin[msg.sender], "not admin");
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        MAX_PER_USER = 5;
        isAdmin[msg.sender] = true;
    }

    function mint(uint amount) external payable {
        if (whitelistOn)
            require(isWhitelisted[msg.sender], "user not whitelisted");
        require(msg.value >= amount * COST_PER_NFT);
        _mint(amount);
    }

    function _mint(uint amount) internal {
        require(amount > 0, "invalid amount");
        require(
            userMints[msg.sender] + amount <= MAX_PER_USER,
            "invalid amount"
        );
        require(totalSupply() + amount <= MAX_SUPPLY, "invalid amount");
        require(!paused, "contract paused");
        userMints[msg.sender] += amount;
        uint256 ts = totalSupply();

        for (uint256 i = 1; i <= amount; ) {
            _safeMint(msg.sender, ts + i);

            unchecked {
                ++i;
            }
        }
    }

    ///---- ADMIN FUNCTIONS ----////

    function addToWhitelist(address whitelistedUser) external onlyAdmin {
        isWhitelisted[whitelistedUser] = true;
    }

    function flipPause() external onlyAdmin {
        paused = !paused;
    }

    function reveal() external onlyAdmin {
        revealed = true;
    }

    ///---- VIEW FUNCTIONS ----////

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        if (!revealed) return "hola";
        return string(abi.encodePacked("hola/", tokenId.toString(), ".json"));
    }
}
