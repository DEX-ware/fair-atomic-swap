eip: 2266
title: Atomic Swap-based American Call Option Contract Standard
author: Runchao Han <runchao.han@monash.edu>, Haoyu Lin <chris.haoyul@gmail.com>, Jiangshan Yu <jiangshan.yu@monash.edu>
discussions-to: https://github.com/ethereum/EIPs/issues/2266
status: Draft
type: Standards Track
category: ERC
created: 2019-08-17
---

<!--You can leave these HTML comments in your merged EIP and delete the visible duplicate text guides, they will not appear and may be helpful to refer to if you edit it again. This is the suggested template for new EIPs. Note that an EIP number will be assigned by an editor. When opening a pull request to submit your EIP, please use an abbreviated title in the filename, `eip-draft_title_abbrev.md`. The title should be 44 characters or less.-->

## Simple Summary
<!--"If you can't explain it simply, you don't understand it well enough." Provide a simplified and layman-accessible explanation of the EIP.-->


A standard for token contracts, providing Atomic Swap-based American Call Option sevice. You can view out an example implementation in the repo here: https://github.com/HAOYUatHZ/fair-atomic-swap/blob/master/src/atomicswap/eip2266/


## Abstarct

The following standard provides functionality to make Atomic Swap-based American Call Option payment. This standard allows ERC20 token holders to atomically exchange their tokens without trusted third parties, which is known as `Atomic Swap`, by the use of Hashed Time-Locked Contract; and to exchange their tokens as a type of financial derivatives, named "American-style Option". More specifically, Hashed Time-Locked Contract is a type of smart contract that use hashlocks and timelocks to require that the receiver of a payment either acknowledge receiving the payment prior to a deadline by generating cryptographic proof of payment or forfeit the ability to claim the payment, returning it to the payer [^1]. And an American-style Option is a contract which gives the option buyer the right to buy or sell an asset, while the buyer can exercise the contract no later than the strike time. After a successful swap, the two parties exchange their tokens, and the participant gets the premium. Otherwise the tokens are refunded back to their original owners. 


## Motivation
<!--The motivation is critical for EIPs that want to change the Ethereum protocol. It should clearly explain why the existing protocol specification is inadequate to address the problem that the EIP solves. EIP submissions without sufficient motivation may be rejected outright.-->

The Atomic Swap protocol enables two parties to exchange cryptocurrencies on different blockchains atomically, by the means of Hash Timelocked Contracts (HTLCs). Also, Atomic Swap-based American Call Option Smart Contract, with built-in premium, mitigate the risk of "_Free Option Problem_"[^2]. Existing standards do not regulate the procedure of Atomic Swap-based American Call Option, and the prerequisites of of each step. This standard aims at specifying the procedure, to prevent any arbitrage opportunity if a user regret about the deal, or try to lock the counter party's token maliciously.


## Specification
<!--The technical specification should describe the syntax and semantics of any new feature. The specification should be detailed enough to allow competing, interoperable implementations for any of the current Ethereum platforms (go-ethereum, parity, cpp-ethereum, ethereumj, ethereumjs, and [others](https://github.com/ethereum/wiki/wiki/Clients)).-->

The Atomic Swap-based American Call Option Smart Contract should follows the syntax and semantics of the stateful smart contract in Ethereum, with hash locks support and time locks support.


### Definitions

+ `initior`: the party who publishes the advertisement of the swap.
+ `participant`: the party who agrees on the advertisement and want to take the deal.
+ `asset`: token(s) to be exchanged.
+ `premium`: the upfront cost that the `initior` pays for the overall profitability of the trade.
+ `redeem`: the action to claim the agreed amount of token.
+ `refund`: the event that the agreed amount of token goes back to the original owner, because of timelock expiration.
+ `secrect`: random number chosen by the `initior`, revealed to allow the `participant` to redeem the fund.
+ `secrect_hash`: hash of the `secrect`, used in the contruction of HTLC. 
+ `timelock`: time limit in the form of block timestamp, ahead of when the fund can only be claimed by a certain party, and otherwise be refunded back to the counter-party after.

### Storage Variables

#### swap

This mapping stores the metadata of the swap contracts, including the parties and tokens involved. Each contract uses different `secretHash`, and is distinguished by the `secretHash`.

```
mapping(bytes32 => Swap) public swap;
```

#### initiatorAsset

This mapping stores the details of the asset the initiator want to sell, including the amount, the timelock and the state. It is asscociated with the swap contract with the same `secretHash`.

```
mapping(bytes32 => InitiatorAsset) public initiatorAsset;
```

#### participantAsset

This mapping stores the details of the asset the participant want to sell, including the amount, the timelock and the state. It is asscociated with the swap contract with the same `secretHash`.

```
mapping(bytes32 => ParticipantAsset) public participantAsset;
```

#### premiumAsset

This mapping stores the details of the premium the initiator attach within the swap contract, including the amount, the timelock and the state. It is asscociated with the swap contract with the same `secretHash`.

```
mapping(bytes32 => PremiumAsset) public premiumAsset;
```


### Methods

#### setup

This function sets up the swap contract, including the both parties involved, the tokens to exchanged, and so on.

```
function setup(bytes32 secretHash, address payable initiator, address tokenA, address tokenB, uint256 initiatorAssetAmount, address payable participant, uint256 participantAssetAmount, uint256 premiumAmount) public payable
```

#### initiate

The initiator invokes this function to lock the token it wants to sell and join the contract.

```
function initiate(bytes32 secretHash, uint256 assetRefundTime) public payable
```

#### fillPremium

The initiator invokes this function to lock the premium.

```
function fillPremium(bytes32 secretHash, uint256 premiumRefundTime) public payable
```

#### participate

The participant invokes this function to lock the token it wants to sell and join the contract.

```
function participate(bytes32 secretHash, uint256 assetRefundTime) public payable
```

#### redeemAsset

One of the parties invokes this function to get the token sold by the counterparty, by providing the preimage of the hash lock.

```
function redeemAsset(bytes32 secret, bytes32 secretHash) public
```

#### refundAsset

One invokes this function to get its token back if the timelock expires.

```
function refundAsset(bytes32 secretHash) public
```

#### redeemPremium

The participant invokes this function to get the premium. This should only succeed if the participant does participate and its token is redeemed/refunded.

```
function redeemPremium(bytes32 secretHash) public
```

#### refundPremium

The initiator invokes this function to get the premium back if the timelock expires.

```
function refundPremium(bytes32 secretHash) public
```


### Events

#### SetUp
This event logs that one of the parties has set the contract up based on a `secrect_hash`, specifying the amount of the `asset` and the `premium`, and the involved parties.

#### Initiated
This event logs that the `initior` has pay for the token to be exchanged.

#### Participated
This event logs that the `participant` has pay for the token to be exchanged.

#### PremiumFilled
This event logs that the `initior` has pay for the `premium`.

#### AssetRedeemed
This event logs that the `asset` has been redeemed by the counter party, and redeemed before the `asset` timelock, providing the preimage of the `secrect_hash`.

#### AssetRefunded
This event logs that the `asset` has been refunded back to the original owner, because of the `asset` timelock expiration.

#### PremiumRedeemed
This event logs that the `premium` has been redeemed by the `participant`, and redeemed before the premium timelock, if the `participant` participates in the swap. This also implies that the `asset` is either redeemed by the `initior` if it can provide the preimage of the `secrect_hash` before  `asset` timelock expires; or refunded by the `participant` if `asset` timelock expires.

#### PremiumRefunded
This event logs that the `premium` has been refunded back to the `initior`, because of the `participant` doesn't participate at all, by the time of `premium` timelock expires.


## Rationale
<!--The rationale fleshes out the specification by describing what motivated the design and why particular design decisions were made. It should describe alternate designs that were considered and related work, e.g. how the feature is supported in other languages. The rationale may also provide evidence of consensus within the community, and should discuss important objections or concerns raised during discussion.-->

__TODO:__

To resolve the "Free Option Problem", the unfair behaviour should receive punishment.

To apply the punishment, it requires that, besides the asset used to exchange, the initiator must put some asset as collateral, which is in fact premium. The transaction for the premium needs to be locked with the same secret hash but with a flipped payout, i.e. when redeemed with the secret, the premium goes back to the initiator and after timelock, the premium goes to the participant as a compensation for initiator not revealing the secret.

However, this introduces a new problem: this time the participant gains the optionality -- it can get the premium without paying anything, by never participating in.

To resolve the new problem, the premium:

+ should be refunded back to the initior if the participant does not participate in at all, or if **the participant's funding is redeemed by the initior**; or
+ should be redeemed for the participant if the initior holds the secret used in hash lock maliciously, which also implies that **the participant's funding is refunded back**.

Such a logic is hard to implement in stateless script system like Bitcoin, because, in the aspect of transaction, **where the premium should go, strictly depends on where the participant's funding goes**, but can be empowered in Ethereum-style stateful systems.

In a word, a simple HTLCs-based Atomic Swap on Spot scenario is natively equivalent to an American Call Option without premium, but adding well-designed premium mechanism mitigates the arbitrage risk for both parties.

Meanwhile, it is also worthy to investigate on HTLCs-based Atomic Swaps on American Call Option scenario, with built-in premium.

In American Call Option with premium, the premium:

+ should be refundable for the initior if the participant doesn't participate; or
+ should be redeemable for the participant if the participant does participate.

## Backwards Compatibility
<!--All EIPs that introduce backwards incompatibilities must include a section describing these incompatibilities and their severity. The EIP must explain how the author proposes to deal with these incompatibilities. EIP submissions without a sufficient backwards compatibility treatise may be rejected outright.-->

This proposal is fully backward compatible. Tokens extended by this proposal should also be following ERC20 standard and HTLC standard. The functionality of ERC20 standard and HTLC standard should not be affected by this proposal but will provide additional functionality to it.


## Implementation
<!--The implementations must be completed before any EIP is given status "Final", but it need not be completed before the EIP is accepted. While there is merit to the approach of reaching consensus on the specification and rationale before writing code, the principle of "rough consensus and running code" is still useful when it comes to resolving many discussions of API details.-->

Please visit [here](https://github.com/HAOYUatHZ/fair-atomic-swap/blob/master/src/atomicswap/eip2266/) to see an example implementation


## Copyright
Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).

[^1]: https://en.bitcoin.it/wiki/Hash_Time_Locked_Contracts
[^2]: [Atomic Swaps and Distributed Exchanges: The Inadvertent Call Option - BitMEX Blog](https://blog.bitmex.com/atomic-swaps-and-distributed-exchanges-the-inadvertent-call-option/) 