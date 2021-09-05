# NFTSet

A simple way to manage your NFTs/collectibles (ERC721), your tokens (ERC20, ERC1155) and ETH in a smart-wallet tokenized as an NFT. 

In other words, NFTSet is a smart contract wallet that's also an NFT (ERC721), so you can manage and transfer its ownership like a collectible.

```
NFTSet can hold ERC721s, ERC1155s, ERC20s and ETH
NFTSet is an ERC721
NFTSet can hold NFTSet(s) too
```

**NB: NFTSet is currently EXPERIMENTAL and NOT AUDITED/REVIEWED. Do Your Own Research and Use At Your Own Risk.**

## Use-cases

1. Sell and transfer collectibles and tokens as a whole (an NFTSet) in a single operation saving on transaction costs
2. Organize your collectibles and tokens in groups (NFTSets) and manage these groups like an NFT
3. Create hiearchies of collections, i.e. collections of collections or mixed assets
4. What can we do if an NFT can be equipped with/hold other NFTs and ERC20s? ... to be released very soon ...


## How to use

### Create an NFTSet
You can call `NFTSetFactory.create(name, symbol)`. 

You will own a new ERC721 with the symbol and the name you specified at `tokenId = 0`

### Deposit assets
Just transfer ERC20, ERC721, ERC1155 and ETH to the desidered NFTSet address.

### Withdraw assets
Based on the category of asset you want to withdraw call on your NFTSet respectively:
- `withdrawERC721(address tokenAddress, uint256 tokenId)` or `safeWithdrawERC721(address tokenAddress, uint256 tokenId)`
- `withdrawERC1155(address tokenAddress, uint256 tokenId, uint256 amount, bytes memory data)`
- `withdrawERC20(address tokenAddress, uint256 amount)`
- `withdrawETH(uint256 amount)`

These methods can be called only by the owner (or the approved spenders).

### Transfer ownership
Your NFTSet is an NFT, technically the owner is the holder of the `tokenId = 0`. Transfer that id to the new desidered owner and you are done. Transfering a smart-wallet has never been easier!

`transferFrom(currentOwner, newOwner, 0)`

### Use your NFTSet as a smart wallet
You NFTSet is smart-wallet and can interact with other smart-contracts. You can execute a generic transaction via

```
execute(
    address to,
    uint256 value,
    bytes memory data,
    bool isDelegateCall,
    uint256 txGas
)
```

e.g. Your NFTSet can lend its tokens to Aave or Compound

### DISCLAIMER: Approved spenders
As soon as you approve your NFTSet to someone else, it can not only transfer your NFTSet but also withdraw the tokens inside of it!
Consider carefully when you delegate these rights, it can be useful (e.g. cold/hot wallet) but can be harmful.