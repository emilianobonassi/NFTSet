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

import "@openzeppelin-upgradeable/contracts/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin-upgradeable/contracts/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin-upgradeable/contracts/token/ERC721/utils/ERC721HolderUpgradeable.sol";
import "@openzeppelin-upgradeable/contracts/token/ERC1155/IERC1155Upgradeable.sol";
import "@openzeppelin-upgradeable/contracts/token/ERC1155/utils/ERC1155HolderUpgradeable.sol";
import "@openzeppelin-upgradeable/contracts/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin-upgradeable/contracts/token/ERC20/utils/SafeERC20Upgradeable.sol";

import "./INFTSet.sol";

contract NFTSetV1 is ERC721Upgradeable, ERC721HolderUpgradeable, ERC1155HolderUpgradeable, INFTSet {
    using SafeERC20Upgradeable for IERC20Upgradeable;

    uint256 public constant OWNER_ID = 0;

    modifier onlyApprovedOrOwner() {
        require(_isApprovedOrOwner(_msgSender(), OWNER_ID), "NFTSet: caller is not owner nor approved");
        _;
    }

    function init(
        address owner,
        string memory name,
        string memory symbol
    ) public virtual override initializer {
        __ERC721_init(name, symbol);
        __ERC721Holder_init();
        __ERC1155Holder_init();
        _mint(owner, OWNER_ID);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Upgradeable, ERC1155ReceiverUpgradeable) returns (bool) {
        return ERC721Upgradeable.supportsInterface(interfaceId) || ERC1155ReceiverUpgradeable.supportsInterface(interfaceId);
    }

    function withdrawERC721(address tokenAddress, uint256 tokenId) public virtual onlyApprovedOrOwner {
        IERC721Upgradeable(tokenAddress).transferFrom(address(this), _msgSender(), tokenId);
    }

    function safeWithdrawERC721(address tokenAddress, uint256 tokenId) public virtual onlyApprovedOrOwner {
        IERC721Upgradeable(tokenAddress).safeTransferFrom(address(this), _msgSender(), tokenId);
    }

    function withdrawERC1155(
        address tokenAddress,
        uint256 tokenId,
        uint256 amount,
        bytes calldata data
    ) public virtual onlyApprovedOrOwner {
        IERC1155Upgradeable(tokenAddress).safeTransferFrom(address(this), _msgSender(), tokenId, amount, data);
    }

    function batchWithdrawERC1155(
        address tokenAddress,
        uint256[] calldata tokenIds,
        uint256[] calldata amounts,
        bytes calldata data
    ) public virtual onlyApprovedOrOwner {
        IERC1155Upgradeable(tokenAddress).safeBatchTransferFrom(address(this), _msgSender(), tokenIds, amounts, data);
    }

    function withdrawERC20(address tokenAddress, uint256 amount) public virtual onlyApprovedOrOwner {
        IERC20Upgradeable(tokenAddress).safeTransfer(_msgSender(), amount);
    }

    function withdrawETH(uint256 amount) public virtual onlyApprovedOrOwner {
        (bool sent, bytes memory data) = _msgSender().call{value: amount}("");
        require(sent, "NFTSet: failed to withdraw Ether");
    }

    function execute(
        address to,
        uint256 value,
        bytes memory data,
        bool isDelegateCall,
        uint256 txGas
    ) public payable virtual onlyApprovedOrOwner {
        bool success;

        if (isDelegateCall) {
            // solhint-disable-next-line no-inline-assembly
            assembly {
                success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
            }
        } else {
            // solhint-disable-next-line no-inline-assembly
            assembly {
                success := call(txGas, to, value, add(data, 0x20), mload(data), 0, 0)
            }
        }

        require(success, "NFTSet: failed execution");
    }

    receive() external payable virtual {}
}
