// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

interface INFTSet {
    function init(
        address owner,
        string memory name,
        string memory symbol
    ) external;
}
