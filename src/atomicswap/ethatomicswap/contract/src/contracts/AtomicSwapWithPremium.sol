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
    // TODO: remove?
    // enum Kind { Initiator, Participant }
    enum State { Empty, Filled, Redeemed, Refunded }
    // TODO: combine?
    enum PremiumState { Empty, Filled, Redeemed }

    struct Swap {
        uint setupTimestamp;
        // TODO: should we use timestamp?
        uint refundTime;
        bytes32 secretHash;
        bytes32 secret;
        address initiator;
        address participant;
        uint256 value;
        // TODO: remove?
        // Kind kind;
        State state;
        uint256 premiumValue;
        PremiumState premiumState;
    }

    mapping(bytes32 => Swap) public swaps;

    event Refunded(
        uint refundTime,
        bytes32 secretHash,
        address refunder,
        uint256 value
    );

    event Redeemed(
        uint redeemTime,
        bytes32 secretHash,
        bytes32 secret,
        address redeemer,
        uint256 value
    );

    event Participated(
        uint participateTimestamp,
        uint setupTimestamp,
        uint refundTime,
        bytes32 secretHash,
        address initiator,
        address participant,
        uint256 value,
        uint256 premiumValue
    );

    event Initiated(
        uint initiateTimestamp,
        uint setupTimestamp,
        uint refundTime,
        bytes32 secretHash,
        address initiator,
        address participant,
        uint256 value,
        uint256 premiumValue
    );

    event PremiumFilled(
        uint fillPremiumTimestamp,
        uint setupTimestamp,
        uint refundTime,
        bytes32 secretHash,
        address initiator,
        address participant,
        uint256 value,
        uint256 premiumValue
    );

    event SetUp(
        uint setupTimestamp,
        uint refundTime,
        bytes32 secretHash,
        address initiator,
        address participant,
        uint256 value,
        uint256 premiumValue
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
        uint preRefundTimestamp = swaps[secretHash].setupTimestamp;
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

    modifier isInitiator(bytes32 secretHash) {
        require(msg.sender == swaps[secretHash].initiator);
        _;
    }

    modifier isEmptyState(bytes32 secretHash) {
        require(swaps[secretHash].state == State.Empty);
        _;
    }

    modifier hasPayment(bytes32 secretHash) {
        require(msg.value == swaps[secretHash].value);
        _;
    }

    modifier fulfillPremiumPayment(bytes32 secretHash) {
        require(swaps[secretHash].premiumState == PremiumState.Empty);
        require(swaps[secretHash].value == msg.value);
        require(swaps[secretHash].Initiator == msg.sender);
        _;
    }

    modifier hasRefundTime(uint refundTime) {
        require(refundTime > 0);
        _;
    }

    //TODO:
    // send prem to set up?
    // config prem redeem time?
    function setup(uint refundTime,
                    bytes32 secretHash,
                    address initiator,
                    address participant,
                    uint256 value,
                    uint256 premiumValue)
        public
        payable
        isInitiator(secretHash)
        hasRefundTime(refundTime)
        isEmptyState(secretHash)
    {
        swaps[secretHash].setupTimestamp = block.timestamp; 
        swaps[secretHash].refundTime = refundTime;
        swaps[secretHash].secretHash = secretHash;
        swaps[secretHash].initiator = initiator;
        swaps[secretHash].participant = participant;
        swaps[secretHash].value = value;
        swaps[secretHash].premiumValue = premiumValue;
        // swaps[secretHash].kind = Kind.Initiator;  //TODO: 
        swaps[secretHash].state = State.Empty;
        swaps[secretHash].premiumState = PremiumState.Empty;
        
        emit SetUp(
            block.timestamp,
            refundTime,
            secretHash,
            initiator,
            participant,
            value,
            premiumValue 
        );
    }

    // the initiator needs to pay for the premium with premiumValue
    function fillPremium(bytes32 secretHash)
        public
        payable
        fulfillPremiumPayment(secretHash)
    {   
        swaps[secretHash].premiumState = PremiumState.Filled;
        
        emit PremiumFilled(
            block.timestamp,
            swaps[secretHash].setupTimestamp,
            swaps[secretHash].refundTime,
            secretHash,
            swaps[secretHash].initiator,
            swaps[secretHash].participant,
            swaps[secretHash].value,
            msg.value
        );
    }

    //TODO: premium here?
    function initiate(bytes32 secretHash)
        public
        payable
        hasPayment(secretHash)
        isEmptyState(secretHash)
    {
        swaps[secretHash].state = State.Filled;
        
        emit Initiated(
            block.timestamp,
            swaps[secretHash].setupTimestamp,
            swaps[secretHash].refundTime,
            swaps[secretHash].secretHash,
            swaps[secretHash].initiator,
            swaps[secretHash].participant,
            msg.value,
            swaps[secretHash].premiumValue
        );
    }

    //TODO: premium here?
    function participate(bytes32 secretHash)
        public
        payable
        hasPayment(secretHash)
        hasRefundTime(refundTime)
        isNotInitiated(secretHash)
    {
        swaps[secretHash].setupTimestamp = block.timestamp;
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
