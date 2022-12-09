# Issuing a token on BNB Chain tutorial

## Prerequisites
BNB Chain is composed of two blockchains - BNB Beacon Chain (BC) and BNB Smart Chain (BSC). The BNB Beacon Chain is the blockchain component that is responsible for the governance of the BNB Chain and manages staking and voting on the BNB Chain. Whereas, the BNB Smart Chain is the blokchain component that is EVM compatible, consensus layers, and with hubs to multi-chains. BNB Chain, one of the most popular blockchains in the world, dedicates to delivering its core infrastructure necessary for future public adoption, and always remains as a community-first and open-source ecosystem built on a permissionless and decentralized environment.

**BEP2**: a token standard for fungible tokens on BNB Beacon Chain, describes a common set of rules for token management within the BNB Chain ecosystem. It introduces the following details of a token on Beacon Chain:

- What information makes a token on Beacon Chain
- What actions can be performed on a token on Beacon Chain

<https://github.com/bnb-chain/BEPs/blob/master/BEP2.md>

**BEP20**: a token standard for fungible tokens on BNB Smart Chain, defines the implementation of APIs for token smart contracts. It is proposed by deriving the ERC20 protocol of Ethereum and provides the basic functionality to transfer tokens, allow tokens to be approved so they can be spent by another on-chain third party, and transfer between BNB Beacon Chain and BNB Smart Chain
<https://github.com/bnb-chain/BEPs/blob/master/BEP20.md>

## Tools used in this tutorial
- Black IDE (To create, compile and interact with Smart Contract)
- bnbcli (BNB Beacon Chain Command Line Interface) <https://github.com/bnb-chain/node/releases>
- Bscscan (the browser of BNB Smart Chain) <https://testnet.bscscan.com/> 
- BNB Beacon Chain Explorer (the browser of BNB Beacon Chain) <https://testnet-explorer.binance.org/> 
- Binance Wallet (Wallet Extension)

## Steps 
Since BSC was created after BC, there are some tokens on BC issued earlier are not existing on BSC yet. In the below steps we will issue a token called BCC (BNB Chain Club token) with a total circulation of 21,000,000 on testnet of BNB Beacon Chain and BNB Smart Chain (BSC).

We will issue 21,000,000 BCC on BC first then 21,000,000 BCC on BSC and process token binding. After binding, those 21,000,000 BCC on BSC will be locked into system build-in smart contract TokenHub. The total circulation will be 21M as we desired. 

On the other hand, if a token is issued on BSC first and want it to circulate on BC, could call the mirror function of TokenManager, which is easier. This tutorial will not cover this, please refer to <https://docs.bnbchain.org/docs/mirror> 
### Issue token BCC on BNB Beacon Chain
1. Import your account mnemonic into tbnbcli and set a passphrase

&nbsp;&nbsp;&nbsp;&nbsp;`$ tbnbcli keys add isaackey --recover`

&nbsp;&nbsp;&nbsp;&nbsp;(The key name after add is customized, here just use isaackey for an example.)

2. Import your account mnemonic into tbnbcli and set a passphrase
3. Issue BCC on BC by

&nbsp;&nbsp;&nbsp;&nbsp;`$ tbnbcli token issue --token-name "BNB Chain Club token" --symbol BCC --total-supply 2100000000000000 --from isaackey  --chain-id Binance-Chain-Ganges   --node=data-seed-pre-2-s1.binance.org:80`

- ***token-name***: it is the long official name, such as "Binance Coin". It is limited to 32 characters.
- ***symbol***: identifier of the token. The length of symbol should be between 2 and 8. 
- ***total-supply***: an int64 boosted by **1e8** for decimal part. The max total supply is 90 billion.
- ***from*** the sender address of the transaction and it will become the owner of the token, all created tokens will be in this account.
- ***chain-id***: “Binance-Chain-Tigris” for Beacon Chain Mainnet, “Binance-Chain-Ganges” for Beacon Chain Testnet
- ***node***: RPC endpoint of testnet
- ***mintable***: that means whether this token can be minted in the future. To set the tokes to be mintable, you need to add --mintable, otherwise, just omit this field to set this token to be non-mintable.
4. Check transaction in BNB Beacon Chain Explorer <https://testnet-explorer.binance.org/tx/1345A0F7BE000A5CC1C529A07F94F3C42046C89BE6D00776F9164713469D3F8B>. Fee on both mainnet and testnet is fixed at 10 BNB. Record the Asset name BCC-134
5. Soon we will see this token appear under BC address in Binance Wallet 
### Issue token BCC on BNB Smart Chain
1. In Black IDE, connect with your Metamask and choose network to BNB Chain Testnet.
2. Create a project called "BCCToken" and choose Coin template

![](images/create_project.png)

3. Prepare the Smart Contract code. Here we will use the BEP20 token template:
https://docs.bnbchain.org/assets/files/BEP20Token-90279eb8ba08bbc0df679f37d7886d68.template
4. Copy template code into Coin.sol, and rename contract BEP20Token to BNBChainClubToken. Modify the below parameters in constructor()
***_name***: official name
***_symbol***: The symbol of the BEP20 token must be exactly identical to the prefix of the BEP2 token(case sensitive).
***_decimals***: by default should be 18
***_totalSupply***: Put the same supply as Beacon Chain

![](images/contract_rename.png)

5. Change Solidity Compiler version to 0.5.16 as our code template is using this version

6. Click Build and Deploy, when deploy choose BNBChainClubToken.json (This is the ABI file of the smart contract).

![](images/deploy_contract.png)

8. Check transaction in Bscscan. https://testnet.bscscan.com/tx/0x994b0af5e8557ea4f55c8490ddfd7699449652fd3d32627987e8f6dc68010f84 No extra fee, just a normal gas fee. Record the address of the token contract.
9. We could add this token contract address to Binance wallet under BSC address.
### Bind token BCC on BNB Beacon Chain & BNB Smart Chain
1. Send bind transaction from Beacon Chain side

&nbsp;&nbsp;&nbsp;&nbsp;`$ tbnbcli bridge bind --symbol BCC-134 --amount 0 --expire-time 1666219723 --contract-address 0xc9919d28bed6ce897dea7edf1a8f05e843750adc --contract-decimals 18 --from isaackey --chain-id Binance-Chain-Ganges --node=data-seed-pre-2-s1.binance.org:80`

- ***symbol***: full identifier of the token we get from above
- ***amount***: the amount to be locked on **BNB Beacon Chain**. Here we want all BCC token stay on BC first, hence we lock 0 here.
- ***expire-time***: when this bind request will be expired in UNIX time, need to be 600 seconds after now
- ***contract-address***: token contract address on BSC
- ***contract-decimals***: same as the code value in the token contract

Crosschain Bind Fee on testnet is fixed 0.1 BNB
### Approve Bind Request on BNB Smart Chain
1. In Black IDE, click on Contract and input our token contract address, it will show available functions to interact with the contract. We choose approve() to grant transfer permission to the system build-in contract TokenManager 0x0000000000000000000000000000000000001008

- ***spender***: TokenManger contract. 
- ***amount***: 21000000000000000000000000 which is all of the circulation (1e18) on **BNB Smart Chain**

<https://testnet.bscscan.com/tx/0xf43d27c9b1c3426953a2501dc38c8e01ff9bfbb5e703d4174cc6edc237142188> 

![](images/approve.png)

2. Input 0x0000000000000000000000000000000000001008 in Black IDE, you will see below because it doesn’t have ABI file. Get ABI file of TokenManager from here: <https://github.com/bnb-chain/bsc-genesis-contract/blob/master/abi/tokenmanager.abi> Add it to ABI Storage

![](images/tokenmanger_missing_abi.png)

3. After ABI is imported, choose approveBind(), we will let TokenManager complete the binding by transferring our specified amount to pegged account TokenHub.

BNB to Send is the fee charged by cross-chain service. TokenManager will call TokenHub, then TokenHub initiates a cross-chain transaction to BC to complete the binding. So there will be a cross-chain transaction and incur a fee. Normally it should be 0.01 BNB.

- ***contractAddr***: Our token contract address
- ***cbep2Symbol***: The full token name on Beacon Chain

![](images/approve_bind.png)

4. Confirm the bind result by

&nbsp;&nbsp;&nbsp;&nbsp;`$ tbnbcli token info --symbol BCC-134 --chain-id Binance-Chain-Ganges --node=data-seed-pre-2-s1.binance.org:80`

You should see "contract\_address" and "contract\_decimals" returned in result.

![](images/bind_result.png)

5. Check the balance of BCC under BSC address in Binance wallet, it should become 0
6. The whole bind has finished. The total cost is ~10.2 BNB. We set total circulation to 21,000,000 BCC on two chains. Now all BCC are on BC, and the amount on BSC has been locked into TokenHub. We could do a cross-chain transfer from BC to BSC now.

![](images/crosschain_transfer.png)


In the above steps, it's worth noting that there is no token name/symbol limitation. You could name it any as you wish. This means there could be several BNB/BUSD/USDT/CAKE .etc tokens on the chain but only one will be the token we want to interact with. Always be careful when dealing with token addresses. Usually, CoinMarketCap will list the official addresses of a token on different chains.

![](images/cmc.png)
