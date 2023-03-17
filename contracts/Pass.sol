// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Password {
    bytes32 correctPass =
        bytes32(
            0x8aca9664752dbae36135fd0956c956fc4a370feeac67485b49bcd4b99608ae41
        );

    function comparePassword(string memory pass) external view returns (bool) {
        return keccak256(abi.encodePacked(pass)) == correctPass;
    }
}
