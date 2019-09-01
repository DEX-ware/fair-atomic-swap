* 823 Token Exchange Standard
    + https://github.com/ethereum/EIPs/blob/master/EIPS/eip-823.md
+ 875 Simpler NFT standard with batching and native atomic swaps
    + https://github.com/ethereum/EIPs/blob/master/EIPS/eip-875.md
+ 1327 Extendable Atomic Swaps
    + https://github.com/ethereum/EIPs/issues/1327
+ 1630 Hashed Time-Locked Contract Standard
    + https://github.com/ethereum/EIPs/issues/1631


---

<!-- 
TODO:
1. fix EIP num
2. fix discussion link
 -->

eip: <to be assigned>
title: Atomic Swap-based American Call Option Contract Standard
author: Runchao Han <runchao.han@monash.edu>, Haoyu Lin <chris.haoyul@gmail.com>, Jiangshan Yu <jiangshan.yu@monash.edu>
discussions-to: https://github.com/HAOYUatHZ/fair-atomic-swap/issues
status: Draft
type: Standards Track
category: ERC
created: 2019-08-17
---

<!--You can leave these HTML comments in your merged EIP and delete the visible duplicate text guides, they will not appear and may be helpful to refer to if you edit it again. This is the suggested template for new EIPs. Note that an EIP number will be assigned by an editor. When opening a pull request to submit your EIP, please use an abbreviated title in the filename, `eip-draft_title_abbrev.md`. The title should be 44 characters or less.-->

## Simple Summary
<!--"If you can't explain it simply, you don't understand it well enough." Provide a simplified and layman-accessible explanation of the EIP.-->

A standard for token contracts, providing Atomic Swap-based American Call Option sevice. You can view out an example implementation in the repo here: https://github.com/HAOYUatHZ/fair-atomic-swap/blob/master/src/eip/


## Abstarct
The following standard provides functionality to make Atomic Swap-based American Call Option payment. This standard allows ERC20 token holders to atomically exchange their tokens without trusted third parties, which is known as `Atomic Swap`, by

<!-- HTLC -->

 ; . 

<!-- 

talk about 

`American-style Option`: is a contract which gives the option buyer the right to buy or sell an asset, while the buyer can exercise the contract no later than the strike time.

 -->



## Motivation
<!--The motivation is critical for EIPs that want to change the Ethereum protocol. It should clearly explain why the existing protocol specification is inadequate to address the problem that the EIP solves. EIP submissions without sufficient motivation may be rejected outright.-->

The Atomic Swap protocol enables two parties to exchange cryptocurrencies on different blockchains atomically. However, the usage of Hash Timelocked Contracts (HTLCs) in Atomic Swap introduces optionality: The initior can abort the deal without receiving any penalty. This problem is known as "Free Option Problem". See [Atomic Swaps and Distributed Exchanges: The Inadvertent Call Option - BitMEX Blog](https://blog.bitmex.com/atomic-swaps-and-distributed-exchanges-the-inadvertent-call-option/) for more details.

According to a research [On the optionality and fairness of Atomic Swaps](https://eprint.iacr.org/2019/896), given the timelock setting (24/48 hrs), the arbitrage can be as profitable as approximately 1% ~ 2.3%, which is non-negligible compared with 0.3% for stock market. Such a arbitrage opportunity can be considered attractive because it's totally risk-free.

Several studies have proposed for solving this problem. e.g.,

+ http://diyhpl.us/wiki/transcripts/scalingbitcoin/tokyo-2018/atomic-swaps/
+ https://coblox.tech/docs/financial_crypto19.pdf. 
 
Their basic idea is that, the transaction for the premium needs to be locked with the same secret hash but with a flipped payout, i.e. when redeemed with the secret, the asset goes back to the initior and after timelock, the premium goes to the participant as a compensation for the initior not revealing the secret. However, this introduces a new problem: the participant can get the premium without paying anything, by never participating in.

Therefore, this EIP aims at address such problems, help more people in the community aware of them, and bring up a fair Atmoic Swap implementation for the community to refer to.


## Specification
<!--The technical specification should describe the syntax and semantics of any new feature. The specification should be detailed enough to allow competing, interoperable implementations for any of the current Ethereum platforms (go-ethereum, parity, cpp-ethereum, ethereumj, ethereumjs, and [others](https://github.com/ethereum/wiki/wiki/Clients)).-->

__TODO:__
> Here, we need to make this EIP to describe a token standard rather than a contract.
> 
> For example, extend this section to two sections: Specification and Interfaces.
Specification describes our interfaces, and Interfaces gives our function headers.

The fair Atomic Swap Smart Contract should follows the syntax and semantics of 
the stateful smart contract in Ethereum, with hash locks support and time locks support.

### Interfaces

### Events

#### SetUp
#### Initiated
#### Participated
#### PremiumFilled
#### AssetRedeemed
#### AssetRefunded
#### PremiumRedeemed
#### PremiumRefunded



## Rationale
<!--The rationale fleshes out the specification by describing what motivated the design and why particular design decisions were made. It should describe alternate designs that were considered and related work, e.g. how the feature is supported in other languages. The rationale may also provide evidence of consensus within the community, and should discuss important objections or concerns raised during discussion.-->

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

This proposal is fully backward compatible. Tokens extended by this proposal should also be following ERC20 standard. The functionality of ERC20 standard should not be affected by this proposal but will provide additional functionality to it.

__TODO:__
talk about stateful?

## Implementation
<!--The implementations must be completed before any EIP is given status "Final", but it need not be completed before the EIP is accepted. While there is merit to the approach of reaching consensus on the specification and rationale before writing code, the principle of "rough consensus and running code" is still useful when it comes to resolving many discussions of API details.-->

Please visit this [page](https://github.com/HAOYUatHZ/fair-atomic-swap/blob/master/src/atomicswap/ethatomicswap/contract/src/contracts/RiskySpeculativeAtomicSwapOption.sol) to see an example implementation



## Copyright
Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
