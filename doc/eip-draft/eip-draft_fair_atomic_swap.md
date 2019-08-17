---
eip: <to be assigned>
title: Fair Atomic Swap Smart Contract
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

This EIP provides Atomic Swap Smart Contract templates under both American Call Option scenario and Spot scenario, to mitigate the arbitrage risk introduced by market fluctuation.

## Abstract
<!--A short (~200 word) description of the technical issue being addressed.-->
A short (~200 word) description of the technical issue being addressed.

## Motivation
<!--The motivation is critical for EIPs that want to change the Ethereum protocol. It should clearly explain why the existing protocol specification is inadequate to address the problem that the EIP solves. EIP submissions without sufficient motivation may be rejected outright.-->
The motivation is critical for EIPs that want to change the Ethereum protocol. It should clearly explain why the existing protocol specification is inadequate to address the problem that the EIP solves. EIP submissions without sufficient motivation may be rejected outright.

## Specification
<!--The technical specification should describe the syntax and semantics of any new feature. The specification should be detailed enough to allow competing, interoperable implementations for any of the current Ethereum platforms (go-ethereum, parity, cpp-ethereum, ethereumj, ethereumjs, and [others](https://github.com/ethereum/wiki/wiki/Clients)).-->
The technical specification should describe the syntax and semantics of any new feature. The specification should be detailed enough to allow competing, interoperable implementations for any of the current Ethereum platforms (go-ethereum, parity, cpp-ethereum, ethereumj, ethereumjs, and [others](https://github.com/ethereum/wiki/wiki/Clients)).

## Rationale
<!--The rationale fleshes out the specification by describing what motivated the design and why particular design decisions were made. It should describe alternate designs that were considered and related work, e.g. how the feature is supported in other languages. The rationale may also provide evidence of consensus within the community, and should discuss important objections or concerns raised during discussion.-->
The rationale fleshes out the specification by describing what motivated the design and why particular design decisions were made. It should describe alternate designs that were considered and related work, e.g. how the feature is supported in other languages. The rationale may also provide evidence of consensus within the community, and should discuss important objections or concerns raised during discussion.-->

## Backwards Compatibility
<!--All EIPs that introduce backwards incompatibilities must include a section describing these incompatibilities and their severity. The EIP must explain how the author proposes to deal with these incompatibilities. EIP submissions without a sufficient backwards compatibility treatise may be rejected outright.-->

There is no backwards incompatibility as what it requires is stateful smart contract, which is already supported in Ethereum.

## Implementation
<!--The implementations must be completed before any EIP is given status "Final", but it need not be completed before the EIP is accepted. While there is merit to the approach of reaching consensus on the specification and rationale before writing code, the principle of "rough consensus and running code" is still useful when it comes to resolving many discussions of API details.-->

**Atomic Swap Smart Contract in Spot Scenario**
```
// Copyright (c) 2019 Chris Haoyu LIN, Runchao HAN, Jiangshan YU

pragma solidity ^0.5.0;

// Notes on security warnings:
//  + block.timestamp is safe to use,
//    given that our timestamp can tolerate a 30-second drift in time;

contract RiskySpeculativeAtomicSwapSpot {
    enum Kind { Initiator, Participant }
    enum AssetState { Empty, Filled, Redeemed, Refunded }
    enum PremiumState { Empty, Filled, Redeemed, Refunded }

    struct Swap {
        bytes32 secretHash;
        bytes32 secret;
        address payable initiator;
        address payable participant;
        Kind kind;
        uint256 assetValue;
        uint256 assetRefundTimestamp;
        AssetState assetState;
        uint256 premiumValue;
        uint256 premiumRefundTimestamp;
        PremiumState premiumState;
    }

    mapping(bytes32 => Swap) public swaps;

    event AssetRefunded(
        uint256 refundTimestamp,
        bytes32 secretHash,
        address refunder,
        uint256 value
    );

    event AssetRedeemed(
        uint256 redeemTimestamp,
        bytes32 secretHash,
        bytes32 secret,
        address redeemer,
        uint256 value
    );

    event PremiumRefunded(
        uint256 refundTimestamp,
        bytes32 secretHash,
        address refunder,
        uint256 value
    );

    event PremiumRedeemed(
        uint256 redeemTimestamp,
        bytes32 secretHash,
        address redeemer,
        uint256 value
    );

    event Participated(
        uint256 participateTimestamp,
        bytes32 secretHash,
        address initiator,
        address participant,
        uint256 assetValue,
        uint256 assetRefundTimestamp,
        uint256 premiumValue,
        uint256 premiumRefundTimestamp
    );

    event Initiated(
        uint256 initiateTimestamp,
        bytes32 secretHash,
        address initiator,
        address participant,
        uint256 assetValue,
        uint256 assetRefundTimestamp,
        uint256 premiumValue,
        uint256 premiumRefundTimestamp
    );

    event PremiumFilled(
        uint256 fillPremiumTimestamp,
        bytes32 secretHash,
        address initiator,
        address participant,
        uint256 assetValue,
        uint256 assetRefundTimestamp,
        uint256 premiumValue,
        uint256 premiumRefundTimestamp
    );

    event SetUp(
        bytes32 secretHash,
        address initiator,
        address participant,
        uint256 assetValue,
        uint256 premiumValue
    );

    constructor() public {}

    // Premium is refundable on blokchian2 when
    // 1. Alice initiates but Bob does not participate
    //   after premium's timelock expires;
    // 2. asset2 is redeemed by Alice;
    modifier isPremiumRefundable(bytes32 secretHash) {
        // on asset2 chain
        require(swaps[secretHash].kind == Kind.Participant);
        // the premium should be deposited
        require(swaps[secretHash].premiumState == PremiumState.Filled);
        // the initiator invokes this method to refund the premium        
        require(swaps[secretHash].initiator == msg.sender);
        // if the asset2 timelock is still valid
        if (block.timestamp <= swaps[secretHash].assetRefundTimestamp) {
            // the asset2 should be redeemded by Alice
            require(swaps[secretHash].assetState == AssetState.Redeemed);
        } else {
            require(block.timestamp > swaps[secretHash].premiumRefundTimestamp);
            require(swaps[secretHash].assetState != AssetState.Refunded);
        }
        _;
    }

    // Premium is redeemable on blockchian2 for Bob when asset2 is refunded
    // which means Alice holds the secret maliciously;
    // and refundable on blokchain1 before premium timelock expires.
    modifier isPremiumRedeemable(bytes32 secretHash) {
        // on asset2 chain
        require(swaps[secretHash].kind == Kind.Participant);
        // the premium should be deposited
        require(swaps[secretHash].premiumState == PremiumState.Filled);
        // the participant invokes this method to redeem the premium
        require(swaps[secretHash].participant == msg.sender);
        // the asset2 should be refunded
        // this also indicates the asset2 timelock is expired
        require(swaps[secretHash].assetState == AssetState.Refunded);
        // the premium timelock should not be expired
        require(block.timestamp <= swaps[secretHash].premiumRefundTimestamp);
        _;
    }

    modifier isAssetRefundable(bytes32 secretHash) {
        require(swaps[secretHash].assetState == AssetState.Filled);
        if (swaps[secretHash].kind == Kind.Initiator) {
            require(swaps[secretHash].initiator == msg.sender);
        } else {
            require(swaps[secretHash].participant == msg.sender);
        }
        require(block.timestamp > swaps[secretHash].assetRefundTimestamp);
        _;
    }

    modifier isAssetRedeemable(bytes32 secretHash, bytes32 secret) {
        require(swaps[secretHash].assetState == AssetState.Filled);
        if (swaps[secretHash].kind == Kind.Initiator) {
            require(swaps[secretHash].participant == msg.sender);
        } else {
            require(swaps[secretHash].initiator == msg.sender);
        }
        require(block.timestamp <= swaps[secretHash].assetRefundTimestamp);
        require(sha256(abi.encodePacked(secret)) == secretHash);
        _;
    }

    modifier isPremiumFilledState(bytes32 secretHash) {
        require(swaps[secretHash].premiumState == PremiumState.Filled);
        _;
    }

    modifier isAssetEmptyState(bytes32 secretHash) {
        require(swaps[secretHash].assetState == AssetState.Empty);
        _;
    }

    modifier isPremiumEmptyState(bytes32 secretHash) {
        require(swaps[secretHash].premiumState == PremiumState.Empty);
        _;
    }

    modifier checkRefundTimestampOverflow(uint256 refundTime) {
        uint256 refundTimestamp = block.timestamp + refundTime;
        require(refundTimestamp > block.timestamp, "calc refundTimestamp overflow");
        require(refundTimestamp > refundTime, "calc refundTimestamp overflow");
        _;
    }

    modifier canInitiate(bytes32 secretHash) {
        require(swaps[secretHash].initiator == msg.sender);
        require(swaps[secretHash].assetValue == msg.value);
        require(swaps[secretHash].assetState == AssetState.Empty);
        _;
    }

    modifier canFillPremium(bytes32 secretHash) {
        require(swaps[secretHash].initiator == msg.sender);
        require(swaps[secretHash].premiumValue == msg.value);
        require(swaps[secretHash].premiumState == PremiumState.Empty);
        _;
    }

    modifier canParticipate(bytes32 secretHash) {
        require(swaps[secretHash].participant == msg.sender);
        require(swaps[secretHash].assetValue == msg.value);
        require(swaps[secretHash].assetState == AssetState.Empty);
        require(swaps[secretHash].premiumState == PremiumState.Filled);
        _;
    }

    // both initiator and participant can set up a contract.
    // zero-value premiumValue indicates that the contract in on initiator's chain.
    function setup(bytes32 secretHash,
                    address payable initiator,
                    address payable participant,
                    uint256 assetValue,
                    uint256 premiumValue)
        public
        payable
        isAssetEmptyState(secretHash)
        isPremiumEmptyState(secretHash)
    {
        swaps[secretHash].secretHash = secretHash;
        swaps[secretHash].initiator = initiator;
        swaps[secretHash].participant = participant;
        if (msg.sender == initiator) {
            swaps[secretHash].kind = Kind.Initiator;
        } else {
            swaps[secretHash].kind = Kind.Participant;
        }
        swaps[secretHash].assetValue = assetValue;
        swaps[secretHash].assetState = AssetState.Empty;
        swaps[secretHash].premiumValue = premiumValue;
        swaps[secretHash].premiumState = PremiumState.Empty;
        
        emit SetUp(
            secretHash,
            initiator,
            participant,
            assetValue,
            premiumValue
        );
    }

    // Initiator needs to pay for the premium with premiumValue
    function fillPremium(bytes32 secretHash, uint256 premiumRefundTime)
        public
        payable
        canFillPremium(secretHash)
        checkRefundTimestampOverflow(premiumRefundTime)
    {   
        swaps[secretHash].premiumState = PremiumState.Filled;
        swaps[secretHash].premiumRefundTimestamp = block.timestamp + premiumRefundTime;
        
        emit PremiumFilled(
            block.timestamp,
            secretHash,
            msg.sender,
            swaps[secretHash].participant,
            swaps[secretHash].assetValue,
            swaps[secretHash].assetRefundTimestamp,
            msg.value,
            swaps[secretHash].premiumRefundTimestamp
        );
    }

    function initiate(bytes32 secretHash, uint256 assetRefundTime)
        public
        payable
        canInitiate(secretHash)
        checkRefundTimestampOverflow(assetRefundTime)
    {
        swaps[secretHash].assetState = AssetState.Filled;
        swaps[secretHash].assetRefundTimestamp = block.timestamp + assetRefundTime;
        
        emit Initiated(
            block.timestamp,
            secretHash,
            msg.sender,
            swaps[secretHash].participant,
            msg.value,
            swaps[secretHash].assetRefundTimestamp,
            swaps[secretHash].premiumValue,
            swaps[secretHash].premiumRefundTimestamp
        );
    }

    function participate(bytes32 secretHash, uint256 assetRefundTime)
        public
        payable
        canParticipate(secretHash)
        checkRefundTimestampOverflow(assetRefundTime)
    {
        swaps[secretHash].assetState = AssetState.Filled;
        swaps[secretHash].assetRefundTimestamp = block.timestamp + assetRefundTime;        
        
        emit Participated(
            block.timestamp,
            secretHash,
            swaps[secretHash].initiator,
            msg.sender,
            msg.value,
            swaps[secretHash].assetRefundTimestamp,
            swaps[secretHash].premiumValue,
            swaps[secretHash].premiumRefundTimestamp
        );
    }

    function redeemAsset(bytes32 secret, bytes32 secretHash)
        public
        isAssetRedeemable(secretHash, secret)
    {
        msg.sender.transfer(swaps[secretHash].assetValue);

        swaps[secretHash].assetState = AssetState.Redeemed;
        swaps[secretHash].secret = secret;

        emit AssetRedeemed(
            block.timestamp,
            secretHash,
            secret,
            msg.sender,
            swaps[secretHash].assetValue
        );
    }

    function refundAsset(bytes32 secretHash)
        public
        isPremiumFilledState(secretHash)
        isAssetRefundable(secretHash)
    {
        msg.sender.transfer(swaps[secretHash].assetValue);

        swaps[secretHash].assetState = AssetState.Refunded;

        emit AssetRefunded(
            block.timestamp,
            swaps[secretHash].secretHash,
            msg.sender,
            swaps[secretHash].assetValue
        );
    }

    function redeemPremium(bytes32 secretHash)
        public
        isPremiumRedeemable(secretHash)
    {
        swaps[secretHash].participant.transfer(swaps[secretHash].premiumValue);
        swaps[secretHash].premiumState = PremiumState.Redeemed;

        emit PremiumRefunded(
            block.timestamp,
            swaps[secretHash].secretHash,
            msg.sender,
            swaps[secretHash].premiumValue
        );
    }
    
    function refundPremium(bytes32 secretHash)
        public
        isPremiumRefundable(secretHash)
    {
        swaps[secretHash].initiator.transfer(swaps[secretHash].premiumValue);
        swaps[secretHash].premiumState = PremiumState.Refunded;

        emit PremiumRefunded(
            block.timestamp,
            swaps[secretHash].secretHash,
            msg.sender,
            swaps[secretHash].premiumValue
        );
    }
}
```

**Atomic Swap Smart Contract in American Call Option Scenario**
```
// Copyright (c) 2019 Chris Haoyu LIN, Runchao HAN, Jiangshan YU

pragma solidity ^0.5.0;

// Notes on security warnings:
//  + block.timestamp is safe to use,
//    given that our timestamp can tolerate a 30-second drift in time;

contract RiskySpeculativeAtomicSwapOption {
    enum Kind { Initiator, Participant }
    enum AssetState { Empty, Filled, Redeemed, Refunded }
    enum PremiumState { Empty, Filled, Redeemed, Refunded }

    struct Swap {
        bytes32 secretHash;
        bytes32 secret;
        address payable initiator;
        address payable participant;
        Kind kind;
        uint256 assetValue;
        uint256 assetRefundTimestamp;
        AssetState assetState;
        uint256 premiumValue;
        uint256 premiumRefundTimestamp;
        PremiumState premiumState;
    }

    mapping(bytes32 => Swap) public swaps;

    event AssetRefunded(
        uint256 refundTimestamp,
        bytes32 secretHash,
        address refunder,
        uint256 value
    );

    event AssetRedeemed(
        uint256 redeemTimestamp,
        bytes32 secretHash,
        bytes32 secret,
        address redeemer,
        uint256 value
    );

    event PremiumRefunded(
        uint256 refundTimestamp,
        bytes32 secretHash,
        address refunder,
        uint256 value
    );

    event PremiumRedeemed(
        uint256 redeemTimestamp,
        bytes32 secretHash,
        address redeemer,
        uint256 value
    );

    event Participated(
        uint256 participateTimestamp,
        bytes32 secretHash,
        address initiator,
        address participant,
        uint256 assetValue,
        uint256 assetRefundTimestamp,
        uint256 premiumValue,
        uint256 premiumRefundTimestamp
    );

    event Initiated(
        uint256 initiateTimestamp,
        bytes32 secretHash,
        address initiator,
        address participant,
        uint256 assetValue,
        uint256 assetRefundTimestamp,
        uint256 premiumValue,
        uint256 premiumRefundTimestamp
    );

    event PremiumFilled(
        uint256 fillPremiumTimestamp,
        bytes32 secretHash,
        address initiator,
        address participant,
        uint256 assetValue,
        uint256 assetRefundTimestamp,
        uint256 premiumValue,
        uint256 premiumRefundTimestamp
    );

    event SetUp(
        bytes32 secretHash,
        address initiator,
        address participant,
        uint256 assetValue,
        uint256 premiumValue
    );

    constructor() public {}

    // Premium is refundable on blockchain2 for Alice only when Alice initiates
    // but Bob does not participate after premium's timelock expires
    modifier isPremiumRefundable(bytes32 secretHash) {
        // on asset2 chain
        require(swaps[secretHash].kind == Kind.Participant);
        // the premium should be deposited
        require(swaps[secretHash].premiumState == PremiumState.Filled);
        // the initiator invokes this method to refund the premium
        require(swaps[secretHash].initiator == msg.sender);
        // asset2 should be empty
        // which means Bob does not participate
        require(swaps[secretHash].assetState == AssetState.Empty);
        require(block.timestamp > swaps[secretHash].premiumRefundTimestamp);
        _;
    }

    // Premium is redeemable on blockchain2 for Bob if Bob participates and refund
    // before premium's timelock expires
    modifier isPremiumRedeemable(bytes32 secretHash) {
        // on asset2 chain
        require(swaps[secretHash].kind == Kind.Participant);
        // the premium should be deposited
        require(swaps[secretHash].premiumState == PremiumState.Filled);
        // the participant invokes this method to redeem the premium
        require(swaps[secretHash].participant == msg.sender);
        // if Bob participates
        require(swaps[secretHash].assetState == AssetState.Refunded || swaps[secretHash].assetState == AssetState.Redeemed);
        // the premium timelock should not be expired
        require(block.timestamp <= swaps[secretHash].premiumRefundTimestamp);
        _;
    }

    modifier isAssetRefundable(bytes32 secretHash) {
        require(swaps[secretHash].assetState == AssetState.Filled);
        if (swaps[secretHash].kind == Kind.Initiator) {
            require(swaps[secretHash].initiator == msg.sender);
        } else {
            require(swaps[secretHash].participant == msg.sender);
        }
        require(block.timestamp > swaps[secretHash].assetRefundTimestamp);
        _;
    }

    modifier isAssetRedeemable(bytes32 secretHash, bytes32 secret) {
        require(swaps[secretHash].assetState == AssetState.Filled);
        if (swaps[secretHash].kind == Kind.Initiator) {
            require(swaps[secretHash].participant == msg.sender);
        } else {
            require(swaps[secretHash].initiator == msg.sender);
        }
        require(block.timestamp <= swaps[secretHash].assetRefundTimestamp);
        require(sha256(abi.encodePacked(secret)) == secretHash);
        _;
    }

    modifier isPremiumFilledState(bytes32 secretHash) {
        require(swaps[secretHash].premiumState == PremiumState.Filled);
        _;
    }

    modifier isAssetEmptyState(bytes32 secretHash) {
        require(swaps[secretHash].assetState == AssetState.Empty);
        _;
    }

    modifier isPremiumEmptyState(bytes32 secretHash) {
        require(swaps[secretHash].premiumState == PremiumState.Empty);
        _;
    }

    modifier checkRefundTimestampOverflow(uint256 refundTime) {
        uint256 refundTimestamp = block.timestamp + refundTime;
        require(refundTimestamp > block.timestamp, "calc refundTimestamp overflow");
        require(refundTimestamp > refundTime, "calc refundTimestamp overflow");
        _;
    }

    modifier canInitiate(bytes32 secretHash) {
        require(swaps[secretHash].initiator == msg.sender);
        require(swaps[secretHash].assetValue == msg.value);
        require(swaps[secretHash].assetState == AssetState.Empty);
        _;
    }

    modifier canFillPremium(bytes32 secretHash) {
        require(swaps[secretHash].initiator == msg.sender);
        require(swaps[secretHash].premiumValue == msg.value);
        require(swaps[secretHash].premiumState == PremiumState.Empty);
        _;
    }

    modifier canParticipate(bytes32 secretHash) {
        require(swaps[secretHash].participant == msg.sender);
        require(swaps[secretHash].assetValue == msg.value);
        require(swaps[secretHash].assetState == AssetState.Empty);
        require(swaps[secretHash].premiumState == PremiumState.Filled);
        _;
    }

    // both initiator and participant can set up a contract.
    // zero-value premiumValue indicates that the contract in on initiator's chain.
    function setup(bytes32 secretHash,
                    address payable initiator,
                    address payable participant,
                    uint256 assetValue,
                    uint256 premiumValue)
        public
        payable
        isAssetEmptyState(secretHash)
        isPremiumEmptyState(secretHash)
    {
        swaps[secretHash].secretHash = secretHash;
        swaps[secretHash].initiator = initiator;
        swaps[secretHash].participant = participant;
        if (msg.sender == initiator) {
            swaps[secretHash].kind = Kind.Initiator;
        } else {
            swaps[secretHash].kind = Kind.Participant;
        }
        swaps[secretHash].assetValue = assetValue;
        swaps[secretHash].assetState = AssetState.Empty;
        swaps[secretHash].premiumValue = premiumValue;
        swaps[secretHash].premiumState = PremiumState.Empty;
        
        emit SetUp(
            secretHash,
            initiator,
            participant,
            assetValue,
            premiumValue
        );
    }

    // Initiator needs to pay for the premium with premiumValue
    function fillPremium(bytes32 secretHash, uint256 premiumRefundTime)
        public
        payable
        canFillPremium(secretHash)
        checkRefundTimestampOverflow(premiumRefundTime)
    {   
        swaps[secretHash].premiumState = PremiumState.Filled;
        swaps[secretHash].premiumRefundTimestamp = block.timestamp + premiumRefundTime;
        
        emit PremiumFilled(
            block.timestamp,
            secretHash,
            msg.sender,
            swaps[secretHash].participant,
            swaps[secretHash].assetValue,
            swaps[secretHash].assetRefundTimestamp,
            msg.value,
            swaps[secretHash].premiumRefundTimestamp
        );
    }

    function initiate(bytes32 secretHash, uint256 assetRefundTime)
        public
        payable
        canInitiate(secretHash)
        checkRefundTimestampOverflow(assetRefundTime)
    {
        swaps[secretHash].assetState = AssetState.Filled;
        swaps[secretHash].assetRefundTimestamp = block.timestamp + assetRefundTime;
        
        emit Initiated(
            block.timestamp,
            secretHash,
            msg.sender,
            swaps[secretHash].participant,
            msg.value,
            swaps[secretHash].assetRefundTimestamp,
            swaps[secretHash].premiumValue,
            swaps[secretHash].premiumRefundTimestamp
        );
    }

    function participate(bytes32 secretHash, uint256 assetRefundTime)
        public
        payable
        canParticipate(secretHash)
        checkRefundTimestampOverflow(assetRefundTime)
    {
        swaps[secretHash].assetState = AssetState.Filled;
        swaps[secretHash].assetRefundTimestamp = block.timestamp + assetRefundTime;        
        
        emit Participated(
            block.timestamp,
            secretHash,
            swaps[secretHash].initiator,
            msg.sender,
            msg.value,
            swaps[secretHash].assetRefundTimestamp,
            swaps[secretHash].premiumValue,
            swaps[secretHash].premiumRefundTimestamp
        );
    }

    function redeemAsset(bytes32 secret, bytes32 secretHash)
        public
        isAssetRedeemable(secretHash, secret)
    {
        msg.sender.transfer(swaps[secretHash].assetValue);

        swaps[secretHash].assetState = AssetState.Redeemed;
        swaps[secretHash].secret = secret;

        emit AssetRedeemed(
            block.timestamp,
            secretHash,
            secret,
            msg.sender,
            swaps[secretHash].assetValue
        );
    }

    function refundAsset(bytes32 secretHash)
        public
        isPremiumFilledState(secretHash)
        isAssetRefundable(secretHash)
    {
        msg.sender.transfer(swaps[secretHash].assetValue);

        swaps[secretHash].assetState = AssetState.Refunded;

        emit AssetRefunded(
            block.timestamp,
            swaps[secretHash].secretHash,
            msg.sender,
            swaps[secretHash].assetValue
        );
    }

    function redeemPremium(bytes32 secretHash)
        public
        isPremiumRedeemable(secretHash)
    {
        swaps[secretHash].participant.transfer(swaps[secretHash].premiumValue);
        swaps[secretHash].premiumState = PremiumState.Redeemed;

        emit PremiumRefunded(
            block.timestamp,
            swaps[secretHash].secretHash,
            msg.sender,
            swaps[secretHash].premiumValue
        );
    }
    
    function refundPremium(bytes32 secretHash)
        public
        isPremiumRefundable(secretHash)
    {
        swaps[secretHash].initiator.transfer(swaps[secretHash].premiumValue);
        swaps[secretHash].premiumState = PremiumState.Refunded;

        emit PremiumRefunded(
            block.timestamp,
            swaps[secretHash].secretHash,
            msg.sender,
            swaps[secretHash].premiumValue
        );
    }
}
```

## Copyright
Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
