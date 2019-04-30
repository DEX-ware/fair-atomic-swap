# Atomic Swap

## Bitcoin-core v0.17.1

1. start a bitcoin-core node by

```bash
bitcoind --regtest --rpcuser=user --rpcpassword=pass -deprecatedrpc=signrawtransaction
```

The RPC port is 18443. The P2P port is 18444.

Note: for `btcd`, the RPC port is 18334. The P2P port is 18444.

2. create 2 wallets and generate a P2PKH address for each of them

```bash
bitcoin-cli --regtest --rpcuser=user --rpcpassword=pass createwallet wallet1
bitcoin-cli --regtest --rpcuser=user --rpcpassword=pass --rpcwallet=wallet1 getnewaddress "" "legacy"
bitcoin-cli --regtest --rpcuser=user --rpcpassword=pass createwallet wallet2
bitcoin-cli --regtest --rpcuser=user --rpcpassword=pass --rpcwallet=wallet2 getnewaddress "" "legacy"
```

3. execute `btcatomicswap`

```bash
cd btcatomicswap
./btcatomicswap --net=regtest --rpcuser=user --rpcpass=pass initiate $btcaddr 1
```

## Ethereum

1. create an account

```bash
geth --datadir node0 account new
```

2. generate `genesis.json` by using `puppeth`

For testing, PoA instead of PoW is used for consensus.

```bash
➜ puppeth

Please specify a network name to administer (no spaces, please)
> testnet
Sweet, you can set this via --network=testnet next time!

INFO [08-21|23:04:14] Administering Ethereum network           name=testnet
WARN [08-21|23:04:14] No previous configurations found         path=/home/xxp/.puppeth/testnet

What would you like to do? (default = stats)
 1. Show network stats
 2. Configure new genesis
 3. Track new remote server
 4. Deploy network components
> 2

Which consensus engine to use? (default = clique)
 1. Ethash - proof-of-work
 2. Clique - proof-of-authority
> 2
# 设置5秒出一个块
How many seconds should blocks take? (default = 15)
> 5
# 输入有签名权限的账户
Which accounts are allowed to seal? (mandatory at least one)
> 0x799a8f7796d1d20b8198a587caaf545cdde5de13
> 0x1458eac314d8fc922029095fae20483f55726017
> 0x3ca60eb49314d867ab75a3c7b3a5aa61c3d6ef71
> 0x
# 输入有预留余额的账户
Which accounts should be pre-funded? (advisable at least one)
> 0x799a8f7796d1d20b8198a587caaf545cdde5de13
> 0x1458eac314d8fc922029095fae20483f55726017
> 0x3ca60eb49314d867ab75a3c7b3a5aa61c3d6ef71
> 0x


Specify your chain/network ID if you want an explicit one (default = random)
> 378

Anything fun to embed into the genesis block? (max 32 bytes)
> 

What would you like to do? (default = stats)
 1. Show network stats
 2. Save existing genesis
 3. Track new remote server
 4. Deploy network components
> 2

Which file to save the genesis into? (default = testnet.json)
> genesis.json
INFO [08-21|23:05:36] Exported existing genesis block 
```

3. start `geth` with the private network

```bash
geth --datadir node0 init genesis.json
geth --datadir node0 --nodiscover --unlock '0' console
```

4. unlock the account and start mining

In `geth` console

```bash
> personal.unlockAccount(eth.coinbase)
Unlock account 0x799a8f7796d1d20b8198a587caaf545cdde5de13
Passphrase: 
true
>
> eth.defaultAccount = eth.coinbase
"0x799a8f7796d1d20b8198a587caaf545cdde5de13"
> 
> miner.start()
```

5. open the RPC interface

```bash
> admin.startRPC("127.0.0.1", 8545, "*", "eth,net,web3,admin,personal")
```

6. deploy the contract

Using [the Remix IDE](http://remix.ethereum.org)

<!-- 
7. execute `ethatomicswap`

```bash
./ethatomicswap --net=testnet --account=0x78fdb0ca831312efc77c2fec51e5525aad68f0a9 -c 0x08383da28ea84351271f7f86026102deafcb4596 initiate 00000000000000000000000000000000000000ff 5.55
```
 -->

7. create a new account and transfer some eth to it

```bash
> personal.newAccount("")
> var amount = web3.toWei(10, "ether")
> eth.sendTransaction({from:eth.accounts[0], to:eth.accounts[1], value: amount})
```
8. query current balance
```
> eth.getBalance(eth.accounts[1])
```

9. invoke initiate() in Remix with parameters:

10. invoke refund() in Remix with parameters:

11. query current balance
```
> eth.getBalance(eth.accounts[1])
```

