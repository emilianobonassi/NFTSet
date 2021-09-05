import pytest


@pytest.fixture
def deployer(accounts):
    yield accounts[0]


@pytest.fixture
def owner(accounts):
    yield accounts[1]


@pytest.fixture
def testNFT(deployer, TestNFT):
    yield TestNFT.deploy({"from": deployer})


@pytest.fixture
def testERC1155(deployer, TestERC1155):
    yield TestERC1155.deploy({"from": deployer})


@pytest.fixture
def testERC20(deployer, TestERC20):
    yield TestERC20.deploy({"from": deployer})


@pytest.fixture
def nftSetV1Logic(deployer, NFTSetV1):
    yield NFTSetV1.deploy({"from": deployer})


@pytest.fixture
def nftSetFactory(deployer, NFTSetFactory, nftSetV1Logic):
    factory = NFTSetFactory.deploy(nftSetV1Logic, {"from": deployer})

    factory.setDefaultLogic(nftSetV1Logic)

    yield factory


@pytest.fixture
def nftSet(owner, nftSetFactory, NFTSetV1):
    def l(name="A", symbol="BBB"):
        tx = nftSetFactory.create(name, symbol, {"from": owner})
        return NFTSetV1.at(tx.events["ProxyCreated"]["proxy"])

    yield l
