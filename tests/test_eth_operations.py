import brownie


def test_withdraw(owner, deployer, nftSet):
    # Test owner and only owner can withdraw
    # Test ownership transfer via traditional ERC721 transfer

    set = nftSet()

    amount = 24 * 1e18
    owner.transfer(set, amount)

    assert set.balance() == amount

    preBalance = owner.balance()
    set.withdrawETH(amount / 4, {"from": owner})

    assert owner.balance() - preBalance == amount / 4

    set.transferFrom(owner, deployer, set.OWNER_ID(), {"from": owner})

    with brownie.reverts("NFTSet: caller is not owner nor approved"):
        set.withdrawETH(amount / 4, {"from": owner})

    preBalance = deployer.balance()
    set.withdrawETH(amount / 4, {"from": deployer})

    assert deployer.balance() - preBalance == amount / 4
