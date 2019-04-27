# Setting a Private Network by Using btcd's Simnet

## Table of Contents
- [Setting a Private Network by Using btcd's Simnet](#setting-a-private-network-by-using-btcds-simnet)
  - [Table of Contents](#table-of-contents)
  - [1. Overview](#1-overview)
  - [2. Getting Started](#2-getting-started)

## 1. Overview

When developing bitcoin applications or testing potential changes, it is often extremely useful to have a test network where transactions are actually mined into blocks and difficulty levels are low enough to generate blocks as needed.

In order to facilitate these scenarios, btcd provides a simulation network (`--simnet`).  The following is an overview of the most important properties that distinguish it from the main network:
- The difficulty starts extremely low to enable fast CPU mining of blocks
- Networking changes:
  - All code related to peer discovery and IP address dissemenation is disabled to help ensure the network remains private
  - The peer and RPC network ports are different
  - A unique network byte sequence is used in the peer-to-peer message protocol so the blocks can't accidentally be crossed with the main network
- All chain and payment address parameters are unique to prevent confusion with the main network:
  - Different genesis block
  - Payment addresses start with different prefixes:
    - Standard pay-to-pubkeyhash (P2PKH) starts with uppercase `S`
    - Standard pay-to-scripthash (P2SH) starts with lowercase `s`
  - Exported hierarchical deterministic extended keys (BIP32) start with different prefixes:
    - Public extended keys start with `spub`
    - Private extended keys start with `sprv`
  - The BIP44 coin type used in HD key paths is lowercase `s`

## 2. Getting Started

Running a single `btcd` node on simnet is simply starting `btcd` with the `--simnet` flag.  However, in order to be really useful, you'll typically want to be able to send coins amongst addresses which implies that blocks will need to be mined and interfacing with a wallet will be needed.

In addition, since there are effectively no coins yet on the new private network, an initial series of blocks will need to be mined which pay to an address you own so there are usable coins to spend.

As previously mentioned, simnet uses unique addresses to prevent confusion with the main network.  Thus, it means that a wallet which supports the address format must be used.  For this, `btcwallet` with the `--simnet` flag can be used.

The following is a command reference to get going:

**NOTE: All of these commands can be simplified by creating config files and making use of them, however the commands here use all switches on the command line to show exactly what is needed for each.**

- Start btcd on simnet:

  `$ btcd --simnet --rpcuser=youruser --rpcpass=SomeDecentp4ssw0rd`

- Create a new simnet wallet:

  `$ btcwallet --simnet --create`

- Start btcwallet on simnet:

  `$ btcwallet --simnet --username=youruser --password=SomeDecentp4ssw0rd`

- Create a new simnet bitcoin address:

  `$ btcctl --simnet --wallet --rpcuser=youruser --rpcpass=SomeDecentp4ssw0rd getnewaddress`

- Stop the initial btcd process and restart it with the mining address set to the output from the previous command:

  `$ btcd --simnet --rpcuser=youruser --rpcpass=SomeDecentp4ssw0rd --miningaddr=S....`

- Instruct btcd to generate enough initial blocks for the first coinbase to mature:

  `$ btcctl --simnet --rpcuser=youruser --rpcpass=SomeDecentp4ssw0rd generate 100`

- Check the wallet balance to ensure the coins are available:

  `$ btcctl --simnet --wallet --rpcuser=youruser --rpcpass=SomeDecentp4ssw0rd getbalance`
  
At this point, there is a fully functional private simnet with coins available to send to other simnet addresses.  Any time one or more transactions are sent, a `generate 1` RPC must be issued to mine a new block with the transactions included.