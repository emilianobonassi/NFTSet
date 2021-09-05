import brownie


def test_withdraw_owner(owner, deployer, nftSet, testERC1155):
    # Test owner and only owner can withdraw an ERC1155
    # Test ownership transfer via traditional ERC1155 transfer

    set = nftSet()

    tokenId = 1
    testERC1155.mint(set, tokenId, 1)

    assert testERC1155.balanceOf(set, tokenId) == 1

    set.withdrawERC1155(testERC1155, tokenId, 1, "", {"from": owner})

    assert testERC1155.balanceOf(owner, tokenId) == 1

    testERC1155.safeTransferFrom(owner, set, tokenId, 1, "", {"from": owner})
    set.transferFrom(owner, deployer, set.OWNER_ID(), {"from": owner})

    with brownie.reverts("NFTSet: caller is not owner nor approved"):
        set.withdrawERC1155(testERC1155, tokenId, 1, "", {"from": owner})

    set.withdrawERC1155(testERC1155, tokenId, 1, "", {"from": deployer})

    assert testERC1155.balanceOf(deployer, tokenId) == 1
