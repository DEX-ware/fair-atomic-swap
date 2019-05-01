# AtomicSwap Smart Contract for the EVM

In this directory you can find the smart contract, written in Solidity,
to be used together with the `ethatomicswap` tool.

## WARNING

This contract has only recently been developed, and has not received any external audits yet. Please use common sense when doing anything that deals with real money! We take no responsibility for any security problem you might experience while using this contract.

## Test

You can test the AtomicSwap smart contract,
found as [/cmd/ethatomicswap/solidity/contracts/AtomicSwap.sol](/cmd/ethatomicswap/solidity/contracts/AtomicSwap.sol) using a single command. It has however following prerequisites:

* Use [nvm](https://github.com/nvm-sh/nvm) to install NodeJS (10.5.0), which bundles _npm_ as well;
* Install truffle: `npm install -g truffle`;
* Install ganache-cli: `npm install -g ganache-cli` so that you don't need to run geth in a private network configured by puppeth as described [here](../../../README.md);

Optionally you can also install and run
Ganache ( <https://truffleframework.com/ganache>).

Once you have fulfilled all prerequisites listed above,
you can run the unit tests provided with the AtomicSwap contract, using:

```
ganache-cli
truffle test
```

## Deploy

// TODO
