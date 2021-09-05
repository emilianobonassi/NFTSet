/*
 .-----------------..----------------. .----------------. .----------------. .----------------. .----------------. 
| .--------------. | .--------------. | .--------------. | .--------------. | .--------------. | .--------------. |
| | ____  _____  | | |  _________   | | |  _________   | | |    _______   | | |  _________   | | |  _________   | |
| ||_   \|_   _| | | | |_   ___  |  | | | |  _   _  |  | | |   /  ___  |  | | | |_   ___  |  | | | |  _   _  |  | |
| |  |   \ | |   | | |   | |_  \_|  | | | |_/ | | \_|  | | |  |  (__ \_|  | | |   | |_  \_|  | | | |_/ | | \_|  | |
| |  | |\ \| |   | | |   |  _|      | | |     | |      | | |   '.___`-.   | | |   |  _|  _   | | |     | |      | |
| | _| |_\   |_  | | |  _| |_       | | |    _| |_     | | |  |`\____) |  | | |  _| |___/ |  | | |    _| |_     | |
| ||_____|\____| | | | |_____|      | | |   |_____|    | | |  |_______.'  | | | |_________|  | | |   |_____|    | |
| |              | | |              | | |              | | |              | | |              | | |              | |
| '--------------' | '--------------' | '--------------' | '--------------' | '--------------' | '--------------' |
 '----------------' '----------------' '----------------' '----------------' '----------------' '----------------' 
*/

// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./ProxyFactoryInitializable.sol";
import "./INFTSet.sol";

contract NFTSetFactory is Ownable, ProxyFactoryInitializable {
    address public defaultLogic;

    constructor(address _defaultLogic) {
        _setDefaultLogic(_defaultLogic);
    }

    function _setDefaultLogic(address _defaultLogic) internal onlyOwner {
        defaultLogic = _defaultLogic;
    }

    function setDefaultLogic(address _defaultLogic) external onlyOwner {
        _setDefaultLogic(_defaultLogic);
    }

    function create(string memory name, string memory symbol) external returns (address proxy, bytes memory returnData) {
        bytes memory data = abi.encodeWithSelector(INFTSet(defaultLogic).init.selector, _msgSender(), name, symbol);

        (proxy, returnData) = deployMinimal(defaultLogic, data);
    }
}
