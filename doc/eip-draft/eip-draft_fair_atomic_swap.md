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

This standard provides functionality to make Atomic Swap-based American Call Option payment. The Hashed Time-Locked Contract (HTLC) [^1] is usually used for implementing Atomic Swaps and can be utilised to construct American Call Options without trusted third party. This standard defines the common way of implementing this protocol. In particular, this EIP defines technical terms, provides interfaces, and gives reference implementations of this protocol.


## Motivation
<!--The motivation is critical for EIPs that want to change the Ethereum protocol. It should clearly explain why the existing protocol specification is inadequate to address the problem that the EIP solves. EIP submissions without sufficient motivation may be rejected outright.-->

Atomic Swap allows users to atomically exchange their tokens without trusted third parties while the HTLC is commonly used for the implementation. However, the HTLC-based Atomic Swap has optionality. More specifically, the swap initiator can choose to proceed or abort the swap for several hours, which gives him time for speculating according to the exchange rate. A discussion[^2] shows that the HTLC-based Atomic Swap is equivalent to an American Call Option in finance. On the other hand,thanks to such optionality, the HTLC-based Atomic Swap can be utilised to construct American Call Options without trusted third party. A paper[^3] proposes a secure Atomic-Swap-based American Call Option protocol on smart contracts. Therefore, to address such issues, this EIP provides an implementation of the protocol.


## Specification
<!--The technical specification should describe the syntax and semantics of any new feature. The specification should be detailed enough to allow competing, interoperable implementations for any of the current Ethereum platforms (go-ethereum, parity, cpp-ethereum, ethereumj, ethereumjs, and [others](https://github.com/ethereum/wiki/wiki/Clients)).-->

The Atomic Swap-based American Call Option smart contract should follow the syntax and semantics of Ethereum smart contracts.

### Definitions

+ `initiator`: the party who publishes the advertisement of the swap.
+ `participant`: the party who agrees on the advertisement and participates in the swap with `initiator`.
+ `asset`: the amount of token(s) to be exchanged.
+ `premium`: the amount of token(s) that `initiator` pays to `participant` as the premium.
+ `redeem`: the action to claim the token from the other party.
+ `refund`: the action to claim the token from the party herself/himself, because of timelock expiration.
+ `secrect`: a random string chosen by `initiator` as the preimage of a hash.
+ `secrectHash`: a string equals to the hash of `secrect`, used for constructing HTLCs.
+ `timelock`: a timestamp representing the timelimit, before when the asset can be redeemed, and otherwise can only be refunded.

### Storage Variables

#### swap

This mapping stores the metadata of the swap contracts, including the parties and tokens involved. Each contract uses different `secretHash`, and is distinguished by `secretHash`.

```
mapping(bytes32 => Swap) public swap;
```

#### initiatorAsset

This mapping stores the detail of the asset initiators want to sell, including the amount, the timelock and the state. It is asscociated with the swap contract with the same `secretHash`.

```
mapping(bytes32 => InitiatorAsset) public initiatorAsset;
```

#### participantAsset

This mapping stores the details of the asset participants want to sell, including the amount, the timelock and the state. It is asscociated with the swap contract with the same `secretHash`.

```
mapping(bytes32 => ParticipantAsset) public participantAsset;
```

#### premiumAsset

This mapping stores the details of the premium initiators attach in the swap contract, including the amount, the timelock and the state. It is asscociated with the swap contract with the same `secretHash`.

```
mapping(bytes32 => Premium) public premium;
```


### Methods

#### setup

This function sets up the swap contract, including the both parties involved, the tokens to exchanged, and so on.

```
function setup(bytes32 secretHash, address payable initiator, address tokenA, address tokenB, uint256 initiatorAssetAmount, address payable participant, uint256 participantAssetAmount, uint256 premiumAmount) public payable
```

#### initiate

The initiator invokes this function to fill and lock the token she/he wants to sell and join the contract.

```
function initiate(bytes32 secretHash, uint256 assetRefundTime) public payable
```

#### fillPremium

The initiator invokes this function to fill and lock the premium.

```
function fillPremium(bytes32 secretHash, uint256 premiumRefundTime) public payable
```

#### participate

The participant invokes this function to fill and lock the token she/he wants to sell and join the contract.

```
function participate(bytes32 secretHash, uint256 assetRefundTime) public payable
```

#### redeemAsset

One of the parties invokes this function to get the token from the other party, by providing the preimage of the hash lock `secret`.

```
function redeemAsset(bytes32 secret, bytes32 secretHash) public
```

#### refundAsset

One of the parties invokes this function to get the token back after the timelock expires.

```
function refundAsset(bytes32 secretHash) public
```

#### redeemPremium

The participant invokes this function to get the premium. This can be invoked only if the participant has already invoked `participate` and the participant's token is redeemed or refunded.

```
function redeemPremium(bytes32 secretHash) public
```

#### refundPremium

The initiator invokes this function to get the premium back after the timelock expires.

```
function refundPremium(bytes32 secretHash) public
```


### Events

#### SetUp

This event indicates that one party has set up the contract using the function `setup()`.

```
event SetUp(bytes32 secretHash, address initiator, address participant, address tokenA, address tokenB, uint256 initiatorAssetAmount, uint256 participantAssetAmount, uint256 premiumAmount);
```

#### Initiated

This event indicates that `initiator` has filled and locked the token to be exchanged using the function `initiate()`.

```
event Initiated(uint256 initiateTimestamp, bytes32 secretHash, address initiator, address participant, address initiatorAssetToken, uint256 initiatorAssetAmount, uint256 initiatorAssetRefundTimestamp);
```

#### Participated

This event indicates that `participant` has filled and locked the token to be exchanged using the function `participate()`.

```
event Participated(uint256 participateTimestamp, bytes32 secretHash, address initiator, address participant, address participantAssetToken, uint256 participantAssetAmount, uint256 participantAssetRefundTimestamp);
```

#### PremiumFilled

This event indicates that `initiator` has filled and locked `premium` using the function `fillPremium()`.

```
event PremiumFilled(uint256 fillPremiumTimestamp, bytes32 secretHash, address initiator, address participant, address premiumToken, uint256 premiumAmount, uint256 premiumRefundTimestamp);
```

#### InitiatorAssetRedeemed/ParticipantAssetRedeemed

These two events indicate that `asset` has been redeemed by the other party before the timelock by providing `secret`.

```
event InitiatorAssetRedeemed(uint256 redeemTimestamp, bytes32 secretHash, bytes32 secret, address redeemer, address assetToken, uint256 amount);
```

```
event ParticipantAssetRedeemed(uint256 redeemTimestamp, bytes32 secretHash, bytes32 secret, address redeemer, address assetToken, uint256 amount);
```

#### InitiatorAssetRefunded/ParticipantAssetRefunded

These two events indicate that `asset` has been refunded by the original owner after the timelock expires.

```
event InitiatorAssetRefunded(uint256 refundTimestamp, bytes32 secretHash, address refunder, address assetToken, uint256 amount);
```

```
event ParticipantAssetRefunded(uint256 refundTimestamp, bytes32 secretHash, address refunder, address assetToken, uint256 amount);
```

#### PremiumRedeemed

This event indicates that `premium` has been redeemed by `participant`. This implies that `asset` is either redeemed by `initiator` if it can provide the preimage of `secrectHash` before  `asset` timelock expires; or refunded by `participant` if `asset` timelock expires.

```
event PremiumRedeemed(uint256 redeemTimestamp,bytes32 secretHash,address redeemer,address token,uint256 amount);
```

#### PremiumRefunded

This event indicates that `premium` has been refunded back to `initiator`, because of `participant` doesn't participate at all, by the time of `premium` timelock expires.

```
event PremiumRefunded(uint256 refundTimestamp, bytes32 secretHash, address refunder, address token, uint256 amount);
```

## Rationale
<!--The rationale fleshes out the specification by describing what motivated the design and why particular design decisions were made. It should describe alternate designs that were considered and related work, e.g. how the feature is supported in other languages. The rationale may also provide evidence of consensus within the community, and should discuss important objections or concerns raised during discussion.-->

+ To achieve the atomicity, HTLC is used.
+ The participant should decide whether to participate after the initiator locks the token and sets up the timelock.
+ The initiator should decide whether to proceed the swap (redeem the tokens from the participant and reveal the preimage of the hash lock), after the participant locks the tokens and sets up the time locks.
+ Premium is redeemable for the participant only if the participant participates in the swap and redeems the initiator's token before premium's timelock expires.
+ Premium is refundable for the initiator only if the initiator initiates but the participant does not participate in the swap at all.


## Backwards Compatibility
<!--All EIPs that introduce backwards incompatibilities must include a section describing these incompatibilities and their severity. The EIP must explain how the author proposes to deal with these incompatibilities. EIP submissions without a sufficient backwards compatibility treatise may be rejected outright.-->

This proposal is fully backward compatible. Functionalities of existing standards will not be affected by this proposal, as it only provides additional features to them.


## Implementation
<!--The implementations must be completed before any EIP is given status "Final", but it need not be completed before the EIP is accepted. While there is merit to the approach of reaching consensus on the specification and rationale before writing code, the principle of "rough consensus and running code" is still useful when it comes to resolving many discussions of API details.-->

Please visit [here](https://github.com/HAOYUatHZ/fair-atomic-swap/blob/master/src/atomicswap/eip2266/) to see an example implementation


## Copyright
Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).

[^1]: [Hash Time Locked Contracts](https://en.bitcoin.it/wiki/Hash_Time_Locked_Contracts)
[^2]: [An Argument For Single-Asset Lightning Network](https://lists.linuxfoundation.org/pipermail/lightning-dev/2019-January/001798.html)
[^3]: [On the optionality and fairness of Atomic Swaps](https://eprint.iacr.org/2019/896)