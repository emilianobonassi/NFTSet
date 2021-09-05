import brownie


def test_exec_generic_transactions(owner, deployer, nftSet, testERC20):
    # Check NFTSet behaves like a smart-contract wallet
    # executing a generic transaction (only by the current owner or approved entities)
    # In the example, transfer an erc20 token from the set to the owner

    set = nftSet()

    amount = 24 * 1e18
    testERC20.mint(set, amount)

    assert testERC20.balanceOf(set) == amount

    data = testERC20.transfer.encode_input(owner, amount)
    set.execute(testERC20, 0, data, False, 250_000, {"from": owner})

    assert testERC20.balanceOf(owner) == amount

    with brownie.reverts("NFTSet: caller is not owner nor approved"):
        set.execute(testERC20, 0, data, False, 250_000, {"from": deployer})
