// TODO:
// maybe distinguish initor&participant

// https://github.com/lukem512/token-swap/blob/master/contracts/TokenSwap.sol

pragma solidity ^0.5.0;

contract ERC2266
{
    // enum Kind { Initiator, Participant }
    enum AnitiatorAssetState { Empty, Filled, Redeemed, Refunded }
    enum ParticipantAssetState { Empty, Filled, Redeemed, Refunded }
    enum PremiumState { Empty, Filled, Redeemed, Refunded }

    struct Swap {
        bytes32 secretHash;
        bytes32 secret;
        address payable initiator;
        address payable participant;
        // Kind kind;
        address initiatorToken;
        address participantToken;
        uint256 initiatorAssetValue;
        uint256 initiatorAssetRefundTimestamp;
        AssetState initiatorAssetState;
        uint256 participantAssetValue;
        uint256 participantAssetRefundTimestamp;
        AssetState participantAssetState;
        uint256 premiumValue;
        uint256 premiumRefundTimestamp;
        PremiumState premiumState;
    }

    mapping(bytes32 => Swap) public swaps;

    // event AssetRefunded(
    //     uint256 refundTimestamp,
    //     bytes32 secretHash,
    //     address refunder,
    //     uint256 value
    // );

    // event AssetRedeemed(
    //     uint256 redeemTimestamp,
    //     bytes32 secretHash,
    //     bytes32 secret,
    //     address redeemer,
    //     uint256 value
    // );

    event PremiumRefunded(
        uint256 refundTimestamp,
        bytes32 secretHash,
        address refunder,
        address token,
        uint256 value
    );

    event PremiumRedeemed(
        uint256 redeemTimestamp,
        bytes32 secretHash,
        address redeemer,
        address token,
        uint256 value
    );

    // event PremiumFilled(
    //     uint256 fillPremiumTimestamp,
    //     bytes32 secretHash,
    //     address initiator,
    //     address participant,
    //     uint256 assetValue,
    //     uint256 assetRefundTimestamp,
    //     uint256 premiumValue,
    //     uint256 premiumRefundTimestamp
    // );

    // event Participated(
    //     uint256 participateTimestamp,
    //     bytes32 secretHash,
    //     address initiator,
    //     address participant,
    //     uint256 assetValue,
    //     uint256 assetRefundTimestamp,
    //     uint256 premiumValue,
    //     uint256 premiumRefundTimestamp
    // );

    // event Initiated(
    //     uint256 initiateTimestamp,
    //     bytes32 secretHash,
    //     address initiator,
    //     address participant,
    //     uint256 assetValue,
    //     uint256 assetRefundTimestamp,
    //     uint256 premiumValue,
    //     uint256 premiumRefundTimestamp
    // );

    // event SetUpByParticipant(
    //     bytes32 secretHash,
    //     address initiator,
    //     address participant,
    //     uint256 assetValue,
    //     uint256 premiumValue
    // );

    // event SetUpByInitiator(
    //     bytes32 secretHash,
    //     address initiator,
    //     address participant,
    //     uint256 assetValue,
    //     uint256 premiumValue
    // );

    constructor() public {}
}