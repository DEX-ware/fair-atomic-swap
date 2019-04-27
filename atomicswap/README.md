# Atomic Swap

## Bitcoin-core

Start a bitcoin-core node by

```bash
bitcoind --regtest --rpcuser=user --rpcpassword=pass -deprecatedrpc=signrawtransaction
```

The RPC port is 18443. The P2P port is 18444.

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











---

Original:

## Example

The first step is for both parties to exchange addresses on both blockchains. If
party A (the initiator) wishes to trade Bitcoin for Decred, party B (the
participant) must provide their Bitcoin address and the initiator must provide
the participant their Decred address.

_Party A runs:_
```
$ dcrctl --testnet --wallet getnewaddress
TsfWDVTAcsLaHUhHnLLKkGnZuJz2vkmM6Vr
```

_Party B runs:_
```
$ bitcoin-cli -testnet getnewaddress
n31og5QGuS28dmHpDH6PQD5wmVQ2K2spAG
```

*Note:* It is normal for neither of these addresses to show any activity on
block explorers.  They are only used in nonstandard scripts that the block
explorers do not recognize.

A initiates the process by using `btcatomicswap` to pay 1.0 BTC into the Bitcoin
contract using B's Bitcoin address, sending the contract transaction, and
sharing the secret hash (*not* the secret), contract, and contract transaction
with B.  The refund transaction can not be sent until the locktime expires, but
should be saved in case a refund is necessary.

_Party A runs:_
```
$ btcatomicswap --net=testnet --rpcuser=user --rpcpass=pass initiate n31og5QGuS28dmHpDH6PQD5wmVQ2K2spAG 1.0
Secret:      3e0b064c97247732a3b345ce7b2a835d928623cb2871c26db4c2539a38e61a16
Secret hash: 29c36b8dd380e0426bdc1d834e74a630bfd5d111

Contract fee: 0.0000744 BTC (0.00020000 BTC/kB)
Refund fee:   0.00000281 BTC (0.00001018 BTC/kB)

Contract (2MwQAMPeRGdCzFzPy7DmCnQudDVGNBFJK8S):
63a61429c36b8dd380e0426bdc1d834e74a630bfd5d1118876a914ebcf822c4a2cdb5f6a6b9c4a59b74d66461da5816704d728bd59b17576a91406fb26221375b1cbe2c17c14f1bc2510b9f8f8ff6888ac

Contract transaction (346f4901dff1d69197850289b481f4331913126a8886861e7d5f27e837e0fe88):
010000000267864c7145e43c84d13b514518cfdc7ca5cf2b04764ed2672caa9c8f6338a3e3010000006b483045022100901602e523f25e9659951d186eec7e8b9df9d194e8013fb6d7a05e4eafdbb61602207b66e0179a42c54d4fcfca2b1ccd89d56253cc83724593187713f6befb37866201210288ef714849ce7735b64ed886d056b80d0a384ca299090f684820d31e7682825afeffffff3ac58ce49bcef3d047ea80281659a78cd7ef8537ca2bfce336abdce41450d2d7000000006b483045022100bd1246fc18d26a9cc85c14fb60655da2f2e845af906504b8ba3acbb1b0ebf08202201ec2cd5a0c94e9e6b971ec3198be0ff57e91115342cd98ccece98d8b18294d86012103406e35c37b3b85481db7b7f7807315720dd6486c25e4f3af93d5d5f21e743881feffffff0248957e01000000001976a914c1925e7398d325820bba18726c387e9d80047ef588ac00e1f5050000000017a9142d913627b881255c417787cc255ccad9a33ce48d8700000000

Refund transaction (45c7c175f333981508229f6fa637410fbbf4f086b657035c07adda6a49207e03):
000000000188fee037e8275f7d1e8686886a12131933f481b48902859791d6f1df01496f3401000000bf4830450221009344b17316054eae5d293b34683177fa5e7c7ba9b0001ebb2b3deca83bef552e022067088b7342bed0155b2ccef69d97cd293faa687f589d2a351aa6e154953c0c65012103a3a9f2c0492a40b134363e82959fa6132b86e0969e0b25109beb53b1debc4324004c5163a61429c36b8dd380e0426bdc1d834e74a630bfd5d1118876a914ebcf822c4a2cdb5f6a6b9c4a59b74d66461da5816704d728bd59b17576a91406fb26221375b1cbe2c17c14f1bc2510b9f8f8ff6888ac0000000001e7dff505000000001976a914f5261c9e58aaa9461923c3f78f8f12f0eec22ed388acd728bd59

Publish contract transaction? [y/N] y
Published contract transaction (346f4901dff1d69197850289b481f4331913126a8886861e7d5f27e837e0fe88)
```

Once A has initialized the swap, B must audit the contract and contract
transaction to verify:

1. The recipient address was the BTC address that was provided to A
2. The contract value is the expected amount of BTC to receive
3. The locktime was set to 48 hours in the future

_Party B runs:_
```
$ btcatomicswap --testnet auditcontract 63a61429c36b8dd380e0426bdc1d834e74a630bfd5d1118876a914ebcf822c4a2cdb5f6a6b9c4a59b74d66461da5816704d728bd59b17576a91406fb26221375b1cbe2c17c14f1bc2510b9f8f8ff6888ac 010000000267864c7145e43c84d13b514518cfdc7ca5cf2b04764ed2672caa9c8f6338a3e3010000006b483045022100901602e523f25e9659951d186eec7e8b9df9d194e8013fb6d7a05e4eafdbb61602207b66e0179a42c54d4fcfca2b1ccd89d56253cc83724593187713f6befb37866201210288ef714849ce7735b64ed886d056b80d0a384ca299090f684820d31e7682825afeffffff3ac58ce49bcef3d047ea80281659a78cd7ef8537ca2bfce336abdce41450d2d7000000006b483045022100bd1246fc18d26a9cc85c14fb60655da2f2e845af906504b8ba3acbb1b0ebf08202201ec2cd5a0c94e9e6b971ec3198be0ff57e91115342cd98ccece98d8b18294d86012103406e35c37b3b85481db7b7f7807315720dd6486c25e4f3af93d5d5f21e743881feffffff0248957e01000000001976a914c1925e7398d325820bba18726c387e9d80047ef588ac00e1f5050000000017a9142d913627b881255c417787cc255ccad9a33ce48d8700000000
Contract address:        2MwQAMPeRGdCzFzPy7DmCnQudDVGNBFJK8S
Contract value:          1 BTC
Recipient address:       n31og5QGuS28dmHpDH6PQD5wmVQ2K2spAG
Author's refund address: mg9sDLhfByfAWFo4zq3JZ7nsLfsN59XPue

Secret hash: 29c36b8dd380e0426bdc1d834e74a630bfd5d111

Locktime: 2017-09-16 13:36:23 +0000 UTC
Locktime reached in 47h56m54s
```

Auditing the contract also reveals the hash of the secret, which is needed for
the next step.

Once B trusts the contract, they may participate in the cross-chain atomic swap
by paying the intended Decred amount (1.0 in this example) into a Decred
contract using the same secret hash.  The contract transaction may be published
at this point.  The refund transaction can not be sent until the locktime
expires, but should be saved in case a refund is necessary.

_Party B runs:_
```
$ dcratomicswap --testnet participate TsfWDVTAcsLaHUhHnLLKkGnZuJz2vkmM6Vr 1.0 29c36b8dd380e0426bdc1d834e74a630bfd5d111
Passphrase:

Contract fee: 0.000251 DCR (0.00100400 DCR/kB)
Refund fee:   0.000301 DCR (0.00100669 DCR/kB)

Contract (TcZpybEVDVTuoE3TCBxW3ui12YEZWrw5ccS):
63a61429c36b8dd380e0426bdc1d834e74a630bfd5d1118876a9149ee19833332a04d2be97b5c99c970191221c070c6704e6dabb59b17576a914b0ec0640c89cf803b8fdbd6e0183c354f71748c46888ac

Contract transaction (a51a7ebc178731016f897684e8e6fbbd65798a84d0a0bd78fe2b53b8384fd918):
010000000137afc6c25b027cb0a1db19a7aac365854796260c4c1077e3e8accae5e4c300e90300000001ffffffff02441455980100000000001976a9144d7c96b6d2360e48a07528332e537d81e068f8ba88ac00e1f50500000000000017a914195fb53333e61a415e9fda21bb991b38b5a4e1c387000000000000000001ffffffffffffffff00000000ffffffff6b483045022100b30971448c93be84c28b98ae159963e9521a84d0c3849821b6e8897d59cf4e6c0220228785cb8d1dba40752e4bd09d99b92b27bc3837b1c547f8b4ee8aba1dfec9310121035a12a086ecd1397f7f68146f4f251253b7c0092e167a1c92ff9e89cf96c68b5f

Refund transaction (836288fa26bbce52342c8569ca4e0db7dec81b2187eb453c1fd5c5d06838f60a):
000000000118d94f38b8532bfe78bda0d0848a7965bdfbe6e88476896f01318717bc7e1aa5010000000000000000016c6bf5050000000000001976a9140b4dae42b84dbad7b7e35f61602cb6a2393f0ae088ace6dabb590000000001ffffffffffffffff00000000ffffffffbe47304402201bd55803eae6de4ea19c618060f82c38e9ca04047c346dc7025f54d8276f13f602205cdf104db74563559e570f186cbc68549d623618b96c7ec971d1a996dab78fbd01210244e4e75a9318ac06656d145c3d3205b2f4f25615698f458e80233c4bb78c91ac004c5163a61429c36b8dd380e0426bdc1d834e74a630bfd5d1118876a9149ee19833332a04d2be97b5c99c970191221c070c6704e6dabb59b17576a914b0ec0640c89cf803b8fdbd6e0183c354f71748c46888ac

Publish contract transaction? [y/N] y
Published contract transaction (a51a7ebc178731016f897684e8e6fbbd65798a84d0a0bd78fe2b53b8384fd918)
```

B now informs A that the Decred contract transaction has been created and
published, and provides the contract details to A.

Just as B needed to audit A's contract before locking their coins in a contract,
A must do the same with B's contract before withdrawing from the contract.  A
audits the contract and contract transaction to verify:

1. The recipient address was the DCR address that was provided to B
2. The contract value is the expected amount of DCR to receive
3. The locktime was set to 24 hours in the future
4. The secret hash matches the value previously known

_Party A runs:_
```
$ dcratomicswap --testnet auditcontract 63a61429c36b8dd380e0426bdc1d834e74a630bfd5d1118876a9149ee19833332a04d2be97b5c99c970191221c070c6704e6dabb59b17576a914b0ec0640c89cf803b8fdbd6e0183c354f71748c46888ac 010000000137afc6c25b027cb0a1db19a7aac365854796260c4c1077e3e8accae5e4c300e90300000001ffffffff02441455980100000000001976a9144d7c96b6d2360e48a07528332e537d81e068f8ba88ac00e1f50500000000000017a914195fb53333e61a415e9fda21bb991b38b5a4e1c387000000000000000001ffffffffffffffff00000000ffffffff6b483045022100b30971448c93be84c28b98ae159963e9521a84d0c3849821b6e8897d59cf4e6c0220228785cb8d1dba40752e4bd09d99b92b27bc3837b1c547f8b4ee8aba1dfec9310121035a12a086ecd1397f7f68146f4f251253b7c0092e167a1c92ff9e89cf96c68b5f
Contract address:        TcZpybEVDVTuoE3TCBxW3ui12YEZWrw5ccS
Contract value:          1 DCR
Recipient address:       TsfWDVTAcsLaHUhHnLLKkGnZuJz2vkmM6Vr
Author's refund address: Tsh9c9aytRaDcbLLxDRcQDRx66aXATh28R3

Secret hash: 29c36b8dd380e0426bdc1d834e74a630bfd5d111

Locktime: 2017-09-15 13:51:34 +0000 UTC
Locktime reached in 23h58m10s
```

Now that both parties have paid into their respective contracts, A may withdraw
from the Decred contract.  This step involves publishing a transaction which
reveals the secret to B, allowing B to withdraw from the Bitcoin contract.

_Party A runs:_
```
$ dcratomicswap --testnet redeem 63a61429c36b8dd380e0426bdc1d834e74a630bfd5d1118876a9149ee19833332a04d2be97b5c99c970191221c070c6704e6dabb59b17576a914b0ec0640c89cf803b8fdbd6e0183c354f71748c46888ac 010000000137afc6c25b027cb0a1db19a7aac365854796260c4c1077e3e8accae5e4c300e90300000001ffffffff02441455980100000000001976a9144d7c96b6d2360e48a07528332e537d81e068f8ba88ac00e1f50500000000000017a914195fb53333e61a415e9fda21bb991b38b5a4e1c387000000000000000001ffffffffffffffff00000000ffffffff6b483045022100b30971448c93be84c28b98ae159963e9521a84d0c3849821b6e8897d59cf4e6c0220228785cb8d1dba40752e4bd09d99b92b27bc3837b1c547f8b4ee8aba1dfec9310121035a12a086ecd1397f7f68146f4f251253b7c0092e167a1c92ff9e89cf96c68b5f 3e0b064c97247732a3b345ce7b2a835d928623cb2871c26db4c2539a38e61a16
Passphrase:

Redeem fee: 0.000334 DCR (0.00100300 DCR/kB)

Redeem transaction (53c2e8bafb8fe36d54bbb1884141a39ea4da83db30bdf3c98ef420cdb332b0e7):
000000000118d94f38b8532bfe78bda0d0848a7965bdfbe6e88476896f01318717bc7e1aa50100000000ffffffff01885ef5050000000000001976a9149551ab760ba64b7e573f54d34c53506676e8145888ace6dabb590000000001ffffffffffffffff00000000ffffffffe0483045022100a1a3b37a67f3ed5d6445a0312e825299b54d91a09e0d1b59b5c0a8baa7c0642102201a0d53e9efe7db8dc47210b446fde6425be82761252ff0ebe620efc183788d86012103395a4a3c8c96ef5e5af6fd80ae42486b5d3d860bf3b41dafc415354de8c7ad80203e0b064c97247732a3b345ce7b2a835d928623cb2871c26db4c2539a38e61a16514c5163a61429c36b8dd380e0426bdc1d834e74a630bfd5d1118876a9149ee19833332a04d2be97b5c99c970191221c070c6704e6dabb59b17576a914b0ec0640c89cf803b8fdbd6e0183c354f71748c46888ac

Publish redeem transaction? [y/N] y
Published redeem transaction (53c2e8bafb8fe36d54bbb1884141a39ea4da83db30bdf3c98ef420cdb332b0e7)
```

Now that A has withdrawn from the Decred contract and revealed the secret, B
must extract the secret from this redemption transaction.  B may watch a block
explorer to see when the Decred contract output was spent and look up the
redeeming transaction.

_Party B runs:_
```
$ dcratomicswap --testnet extractsecret 000000000118d94f38b8532bfe78bda0d0848a7965bdfbe6e88476896f01318717bc7e1aa50100000000ffffffff01885ef5050000000000001976a9149551ab760ba64b7e573f54d34c53506676e8145888ace6dabb590000000001ffffffffffffffff00000000ffffffffe0483045022100a1a3b37a67f3ed5d6445a0312e825299b54d91a09e0d1b59b5c0a8baa7c0642102201a0d53e9efe7db8dc47210b446fde6425be82761252ff0ebe620efc183788d86012103395a4a3c8c96ef5e5af6fd80ae42486b5d3d860bf3b41dafc415354de8c7ad80203e0b064c97247732a3b345ce7b2a835d928623cb2871c26db4c2539a38e61a16514c5163a61429c36b8dd380e0426bdc1d834e74a630bfd5d1118876a9149ee19833332a04d2be97b5c99c970191221c070c6704e6dabb59b17576a914b0ec0640c89cf803b8fdbd6e0183c354f71748c46888ac 29c36b8dd380e0426bdc1d834e74a630bfd5d111
Secret: 3e0b064c97247732a3b345ce7b2a835d928623cb2871c26db4c2539a38e61a16
```

With the secret known, B may redeem from A's Bitcoin contract.

_Party B runs:_
```
$ btcatomicswap --testnet --rpcuser=user --rpcpass=pass redeem 63a61429c36b8dd380e0426bdc1d834e74a630bfd5d1118876a914ebcf822c4a2cdb5f6a6b9c4a59b74d66461da5816704d728bd59b17576a91406fb26221375b1cbe2c17c14f1bc2510b9f8f8ff6888ac 010000000267864c7145e43c84d13b514518cfdc7ca5cf2b04764ed2672caa9c8f6338a3e3010000006b483045022100901602e523f25e9659951d186eec7e8b9df9d194e8013fb6d7a05e4eafdbb61602207b66e0179a42c54d4fcfca2b1ccd89d56253cc83724593187713f6befb37866201210288ef714849ce7735b64ed886d056b80d0a384ca299090f684820d31e7682825afeffffff3ac58ce49bcef3d047ea80281659a78cd7ef8537ca2bfce336abdce41450d2d7000000006b483045022100bd1246fc18d26a9cc85c14fb60655da2f2e845af906504b8ba3acbb1b0ebf08202201ec2cd5a0c94e9e6b971ec3198be0ff57e91115342cd98ccece98d8b18294d86012103406e35c37b3b85481db7b7f7807315720dd6486c25e4f3af93d5d5f21e743881feffffff0248957e01000000001976a914c1925e7398d325820bba18726c387e9d80047ef588ac00e1f5050000000017a9142d913627b881255c417787cc255ccad9a33ce48d8700000000 3e0b064c97247732a3b345ce7b2a835d928623cb2871c26db4c2539a38e61a16
Redeem fee: 0.00000314 BTC (0.00001016 BTC/kB)

Redeem transaction (c49e6fd0057b601dbb8856ad7b3fcb45df626696772f6901482b08df0333e5a0):
000000000188fee037e8275f7d1e8686886a12131933f481b48902859791d6f1df01496f3401000000e0483045022100f43430384ca5ecfc9ca31dd074d223836cef4801b3644c651c3a30d80fbf63b8022017dae9e7ec6f3f5ee0e0b60d146963ba85d9b31003d7f60852126f2a35492759012103b10e3690bcaf0eae7098ec794666963803bcec5acfbe6a112bc8cdc93797f002203e0b064c97247732a3b345ce7b2a835d928623cb2871c26db4c2539a38e61a16514c5163a61429c36b8dd380e0426bdc1d834e74a630bfd5d1118876a914ebcf822c4a2cdb5f6a6b9c4a59b74d66461da5816704d728bd59b17576a91406fb26221375b1cbe2c17c14f1bc2510b9f8f8ff6888acffffffff01c6dff505000000001976a914e1fce397007bad3ce051f0b1c3c7587f016cd76a88acd728bd59

Publish redeem transaction? [y/N] y
Published redeem transaction (c49e6fd0057b601dbb8856ad7b3fcb45df626696772f6901482b08df0333e5a0)
```

The cross-chain atomic swap is now completed and successful.  This example was
performed on the public Bitcoin and Decred testnet blockchains.  For reference,
here are the four transactions involved:

| Description                   | Transaction                                                                                                                                                             |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Bitcoin contract created by A | [346f4901dff1d69197850289b481f4331913126a8886861e7d5f27e837e0fe88](https://www.blocktrail.com/tBTC/tx/346f4901dff1d69197850289b481f4331913126a8886861e7d5f27e837e0fe88) |
| Decred contract created by B  | [a51a7ebc178731016f897684e8e6fbbd65798a84d0a0bd78fe2b53b8384fd918](https://testnet.decred.org/tx/a51a7ebc178731016f897684e8e6fbbd65798a84d0a0bd78fe2b53b8384fd918)      |
| A's Decred redemption         | [53c2e8bafb8fe36d54bbb1884141a39ea4da83db30bdf3c98ef420cdb332b0e7](https://testnet.decred.org/tx/53c2e8bafb8fe36d54bbb1884141a39ea4da83db30bdf3c98ef420cdb332b0e7)      |
| B's Bitcoin redemption        | [c49e6fd0057b601dbb8856ad7b3fcb45df626696772f6901482b08df0333e5a0](https://www.blocktrail.com/tBTC/tx/c49e6fd0057b601dbb8856ad7b3fcb45df626696772f6901482b08df0333e5a0) |

If at any point either party attempts to fraud (e.g. creating an invalid
contract, not revealing the secret and refunding, etc.) both parties have the
ability to issue the refund transaction created in the initiate/participate step
and refund the contract.