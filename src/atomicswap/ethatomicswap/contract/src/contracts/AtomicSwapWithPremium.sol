// Copyright (c) 2017 Altcoin Exchange, Inc

// Copyright (c) 2018 BetterToken BVBA
// Use of this source code is governed by an MIT
// license that can be found at https://github.com/rivine/rivine/blob/master/LICENSE.

// Copyright (c) 2019 Chris Haoyu LIN, Runchao HAN, Jiangshan YU

pragma solidity ^0.5.0;

// Notes on security warnings:
//  + block.timestamp is safe to use,
//    given that our timestamp can tolerate a 30-second drift in time;

contract AtomicSwapWithPremium {
    enum Kind { Initiator, Participant }
    enum State { Empty, Filled, Redeemed, Refunded }
    enum PremiumState { Empty, Filled, Redeemed }

    struct Swap {
        uint initTimestamp;
        uint refundTime;
        bytes32 secretHash;
        bytes32 secret;
        address initiator;
        address participant;
        uint256 value;
        Kind kind;
        State state;
        uint256 premiumValue;
        PremiumState premiumState;
    }

    mapping(bytes32 => Swap) public swaps;

    //TODO: premium here?
    event Refunded(
        uint refundTime,
        bytes32 secretHash,
        address refunder,
        uint256 value
    );

    //TODO: premium here?
    event Redeemed(
        uint redeemTime,
        bytes32 secretHash,
        bytes32 secret,
        address redeemer,
        uint256 value
    );

    //TODO: premium here?
    event Participated(
        uint initTimestamp,
        uint refundTime,
        bytes32 secretHash,
        address initiator,
        address participant,
        uint256 value
    );

    //TODO: premium here?
    event Initiated(
        uint initTimestamp,
        uint refundTime,
        bytes32 secretHash,
        address initiator,
        address participant,
        uint256 value
    );

    constructor() public {}

    //TODO: premium here?
    modifier isRefundable(bytes32 secretHash, address refunder) {
        require(swaps[secretHash].state == State.Filled);
        if (swaps[secretHash].kind == Kind.Participant) {
            require(swaps[secretHash].participant == refunder);
        } else {
            require(swaps[secretHash].initiator == refunder);
        }
        uint preRefundTimestamp = swaps[secretHash].initTimestamp;
        preRefundTimestamp += swaps[secretHash].refundTime;
        require(block.timestamp > preRefundTimestamp);
        _;
    }

    //TODO: premium here?
    modifier isRedeemable(bytes32 secretHash, bytes32 secret, address redeemer) {
        require(swaps[secretHash].state == State.Filled);
        if (swaps[secretHash].kind == Kind.Participant) {
            require(swaps[secretHash].initiator == redeemer);
        } else {
            require(swaps[secretHash].participant == redeemer);
        }
        require(sha256(abi.encodePacked(secret)) == secretHash);
        _;
    }

    //TODO: premium here?
    modifier isInitiator(bytes32 secretHash) {
        require(msg.sender == swaps[secretHash].initiator);
        _;
    }

    //TODO:
    modifier isNotInitiated(bytes32 secretHash) {
        require(swaps[secretHash].state == State.Empty);
        _;
    }

    modifier hasPayment() {
        require(msg.value > 0);
        _;
    }

    modifier hasRefundTime(uint refundTime) {
        require(refundTime > 0);
        _;
    }

    //TODO: premium here?
    function setup(uint refundTime, bytes32 secretHash, address participant)
        public
        payable
        hasRefundTime(refundTime)
        isNotInitiated(secretHash)
    {

    }

    //TODO: premium here?
    function initiate(uint refundTime, bytes32 secretHash, address participant)
        public
        payable
        hasPayment()
        hasRefundTime(refundTime)
        isNotInitiated(secretHash)
    {
        swaps[secretHash].initTimestamp = block.timestamp;
        swaps[secretHash].refundTime = refundTime;
        swaps[secretHash].secretHash = secretHash;
        swaps[secretHash].initiator = msg.sender;
        swaps[secretHash].participant = participant;
        swaps[secretHash].value = msg.value;
        swaps[secretHash].kind = Kind.Initiator;
        swaps[secretHash].state = State.Filled;
        emit Initiated(
            block.timestamp,
            refundTime,
            secretHash,
            msg.sender,
            participant,
            msg.value
        );
    }

    //TODO: premium here?
    function participate(uint refundTime, bytes32 secretHash, address initiator)
        public
        payable
        hasPayment()
        hasRefundTime(refundTime)
        isNotInitiated(secretHash)
    {
        swaps[secretHash].initTimestamp = block.timestamp;
        swaps[secretHash].refundTime = refundTime;
        swaps[secretHash].secretHash = secretHash;
        swaps[secretHash].initiator = initiator;
        swaps[secretHash].participant = msg.sender;
        swaps[secretHash].value = msg.value;
        swaps[secretHash].kind = Kind.Participant;
        swaps[secretHash].state = State.Filled;
        emit Participated(
            block.timestamp,
            refundTime,
            secretHash,
            initiator,
            msg.sender,
            msg.value
        );
    }

    //TODO: premium here?
    function redeem(bytes32 secret, bytes32 secretHash)
        public
        isRedeemable(secretHash, secret, msg.sender)
    {
        msg.sender.transfer(swaps[secretHash].value);

        swaps[secretHash].state = State.Redeemed;
        swaps[secretHash].secret = secret;

        emit Redeemed(
            block.timestamp,
            swaps[secretHash].secretHash,
            swaps[secretHash].secret,
            msg.sender,
            swaps[secretHash].value
        );
    }

    //TODO: premium here?
    function refund(bytes32 secretHash)
        public
        isRefundable(secretHash, msg.sender)
    {
        msg.sender.transfer(swaps[secretHash].value);

        swaps[secretHash].state = State.Refunded;

        emit Refunded(
            block.timestamp,
            swaps[secretHash].secretHash,
            msg.sender,
            swaps[secretHash].value
        );
    }
}
