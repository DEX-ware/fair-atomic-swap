pragma solidity ^0.5.0;

// Notes on security warnings:
//  + block.timestamp is safe to use,
//    given that our timestamp can tolerate a 30-second drift in time;

// use openzeppelin-solidity/contracts/math/SafeMath.sol
import "./SafeMath.sol";

contract NonSpeculativeAtomicSwap {
    using SafeMath for uint256;

    enum Kind { Initiator, Participant }
    enum State { Empty, Filled, Redeemed, Refunded }

    struct Swap {
        uint initTimestamp;
        uint refundTime;
        bytes32 secretHash;
        bytes32 secret;
        address payable initiator;
        address payable participant;
        uint256 value;
        uint256 refundPercent;
        Kind kind;
        State state;
    }

    mapping(bytes32 => Swap) public swaps;

    event Refunded(
        uint refundTime,
        bytes32 secretHash,
        address refunder,
        uint256 refundedValue,
        uint256 lostValue
    );

    event Redeemed(
        uint redeemTime,
        bytes32 secretHash,
        bytes32 secret,
        address redeemer,
        uint256 value
    );

    event Participated(
        uint initTimestamp,
        uint refundTime,
        bytes32 secretHash,
        address initiator,
        address participant,
        uint256 value,
        uint256 refundPercent
    );

    event Initiated(
        uint initTimestamp,
        uint refundTime,
        bytes32 secretHash,
        address initiator,
        address participant,
        uint256 value,
        uint256 refundPercent
    );

    constructor() public {}

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

    modifier isNotInitiated(bytes32 secretHash) {
        require(swaps[secretHash].state == State.Empty);
        _;
    }

    modifier hasNoNilValues(uint refundTime) {
        require(msg.value > 0);
        require(refundTime > 0);
        _;
    }

    function initiate(uint refundTime, uint256 refundPercent, bytes32 secretHash, address payable participant)
        public
        payable
        hasNoNilValues(refundTime)
        isNotInitiated(secretHash)
    {
        swaps[secretHash].initTimestamp = block.timestamp;
        swaps[secretHash].refundTime = refundTime;
        swaps[secretHash].secretHash = secretHash;
        swaps[secretHash].initiator = msg.sender;
        swaps[secretHash].participant = participant;
        swaps[secretHash].value = msg.value;
        swaps[secretHash].refundPercent = refundPercent;
        swaps[secretHash].kind = Kind.Initiator;
        swaps[secretHash].state = State.Filled;
       
        emit Initiated(
            block.timestamp,
            refundTime,
            secretHash,
            msg.sender,
            participant,
            msg.value,
            refundPercent
        );
    }

    function participate(uint refundTime, uint256 refundPercent, bytes32 secretHash, address payable initiator)
        public
        payable
        hasNoNilValues(refundTime)
        isNotInitiated(secretHash)
    {
        swaps[secretHash].initTimestamp = block.timestamp;
        swaps[secretHash].refundTime = refundTime;
        swaps[secretHash].secretHash = secretHash;
        swaps[secretHash].initiator = initiator;
        swaps[secretHash].participant = msg.sender;
        swaps[secretHash].value = msg.value;
        swaps[secretHash].refundPercent = refundPercent;
        swaps[secretHash].kind = Kind.Participant;
        swaps[secretHash].state = State.Filled;
       
        emit Participated(
            block.timestamp,
            refundTime,
            secretHash,
            initiator,
            msg.sender,
            msg.value,
            refundPercent
        );
    }

    // redeem fully redeems the locked value
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

    // refund partially refunds the locked value per agreement
    function refund(bytes32 secretHash)
        public
        isRefundable(secretHash, msg.sender)
    {
        uint256 refundedValue = swaps[secretHash].value;
        uint256 lostValue = 0;

        if (swaps[secretHash].kind == Kind.Initiator) {
            refundedValue = swaps[secretHash].value.div(100).mul(swaps[secretHash].refundPercent);
            lostValue = swaps[secretHash].value.sub(refundedValue);
            swaps[secretHash].initiator.transfer(refundedValue);
            swaps[secretHash].participant.transfer(lostValue);
        } else {
            // equivalent to `msg.sender.transfer(swaps[secretHash].value);`
            swaps[secretHash].participant.transfer(refundedValue);
        }
        

        swaps[secretHash].state = State.Refunded;

        emit Refunded(
            block.timestamp,
            swaps[secretHash].secretHash,
            msg.sender,
            refundedValue,
            lostValue
        );
    }
}
