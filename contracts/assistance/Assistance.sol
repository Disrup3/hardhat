// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IMocktoken.sol";

contract Assistance {
    struct Class {
        uint id;
        uint limitTimestamp;
        bytes32 password;
        bool hasPassword;
    }

    IMockToken public immutable D3Token;
    bytes public currentPassWordHash;
    uint public currentClassId;

    mapping(address => bool) public students;
    mapping(address => bool) public _admins;
    mapping(address => uint) public counter;
    mapping(uint => mapping(address => bool)) public assistanceTracker;

    Class[] public classes;
    // eventos

    event ClassCreated(uint indexed id, uint createdAt);
    event student_asisted(
        uint indexed classId,
        address indexed student,
        uint timestamp
    );
    // mapping de clases

    modifier onlyAdmin() {
        require(_admins[msg.sender], "caller not admin");
        _;
    }

    modifier onlyStudent() {
        require(students[msg.sender], "caller not student");
        _;
    }

    constructor(IMockToken _d3Token) {
        D3Token = _d3Token;
        _admins[msg.sender] = true;
    }

    function createClass(
        bytes memory password,
        bool hasPassword
    ) external onlyAdmin {
        Class memory _class;
        uint id = classes.length;
        currentClassId = id;

        _class.id = id;
        _class.limitTimestamp = block.timestamp + 5 minutes;
        _class.password = hasPassword ? bytes32(password) : bytes32("");
        _class.hasPassword = hasPassword;

        emit ClassCreated(id, block.timestamp);
        classes.push(_class);
    }

    function assistClass(uint id, string memory password) external onlyStudent {
        Class storage class = classes[id];
        require(block.timestamp <= class.limitTimestamp, "out of range");

        if (class.hasPassword) {
            require(
                keccak256(abi.encodePacked(password)) == class.password,
                "invalid password"
            );
        }

        if (counter[msg.sender] == 4) {
            D3Token.mintTo(msg.sender, 50);
            counter[msg.sender] = 0;
        } else {
            D3Token.mintTo(msg.sender, 10);
            counter[msg.sender]++;
        }

        assistanceTracker[id][msg.sender] = true;
        emit student_asisted(class.id, msg.sender, block.timestamp);
    }
}
