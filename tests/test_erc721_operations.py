import brownie


def test_withdraw_owner(owner, deployer, nftSet, testNFT):
    # Test owner and only owner can withdraw an ERC721
    # Test ownership transfer via traditional ERC721 transfer

    set = nftSet()

    tokenId = 1
    testNFT.mint(set, tokenId)

    assert testNFT.ownerOf(tokenId) == set

    set.withdrawERC721(testNFT, tokenId, {"from": owner})

    assert testNFT.ownerOf(tokenId) == owner

    testNFT.safeTransferFrom(owner, set, tokenId, {"from": owner})
    set.transferFrom(owner, deployer, set.OWNER_ID(), {"from": owner})

    with brownie.reverts("NFTSet: caller is not owner nor approved"):
        set.withdrawERC721(testNFT, tokenId, {"from": owner})

    set.safeWithdrawERC721(testNFT, tokenId, {"from": deployer})

    assert testNFT.ownerOf(tokenId) == deployer
