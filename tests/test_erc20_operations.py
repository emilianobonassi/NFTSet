import brownie


def test_withdraw(owner, deployer, nftSet, testERC20):
    # Test owner and only owner can withdraw an ERC20
    # Test ownership transfer via traditional ERC20 transfer

    set = nftSet()

    amount = 24 * 1e18
    testERC20.mint(set, amount)

    assert testERC20.balanceOf(set) == amount

    preBalance = testERC20.balanceOf(owner)
    set.withdrawERC20(testERC20, amount / 4, {"from": owner})

    assert testERC20.balanceOf(owner) - preBalance == amount / 4

    set.transferFrom(owner, deployer, set.OWNER_ID(), {"from": owner})

    with brownie.reverts("NFTSet: caller is not owner nor approved"):
        set.withdrawERC20(testERC20, amount / 4, {"from": owner})

    preBalance = testERC20.balanceOf(deployer)
    set.withdrawERC20(testERC20, amount / 4, {"from": deployer})

    assert testERC20.balanceOf(deployer) - preBalance == amount / 4
