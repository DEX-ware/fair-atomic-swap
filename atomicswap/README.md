# Atomic Swap

## Bitcoin-core

Start a bitcoin-core node by

```bash
bitcoind --regtest --rpcuser=user --rpcpassword=pass -deprecatedrpc=signrawtransaction
```

The RPC port is 18443. The P2P port is 18444.

Note: for `btcd`, the RPC port is 18334. The P2P port is 18444.

Generate a Bitcoin P2PKH address

```bash
bitcoin-cli --regtest getnewaddress "" "legacy"
```

Then execute `btcatomicswap`

```bash
cd btcatomicswap
./btcatomicswap --net=regtest --rpcuser=user --rpcpass=pass initiate $btcaddr 1
```

## Ethereum
