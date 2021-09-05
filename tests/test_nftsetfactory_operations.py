import brownie


def test_create_nftset(owner, nftSet):
    # Create a NFTSet and verify attributes

    setName = "My NFT Collection"
    setSymbol = "MNC"
    set = nftSet(setName, setSymbol)

    assert set.name() == setName
    assert set.symbol() == setSymbol
    assert set.ownerOf(set.OWNER_ID()) == owner


def test_create_nftset(owner, nftSet):
    # Test cannot be initialized more than once

    setName = "My NFT Collection"
    setSymbol = "MNC"
    set = nftSet(setName, setSymbol)

    with brownie.reverts("Initializable: contract is already initialized"):
        set.init(owner, setName, setSymbol, {"from": owner})


def test_change_logic(deployer, owner, nftSetFactory, TestNFTSetV2):
    # Test default logic is changable (only by owner) and the deployer use it

    logic = TestNFTSetV2.deploy({"from": deployer})
    nftSetFactory.setDefaultLogic(logic, {"from": deployer})

    assert nftSetFactory.defaultLogic() == logic

    tx = nftSetFactory.create("My NFT Collection", "MNC", {"from": owner})
    set = TestNFTSetV2.at(tx.events["ProxyCreated"]["proxy"])

    assert set.version() == "V2"

    with brownie.reverts("Ownable: caller is not the owner"):
        nftSetFactory.setDefaultLogic(logic, {"from": owner})
