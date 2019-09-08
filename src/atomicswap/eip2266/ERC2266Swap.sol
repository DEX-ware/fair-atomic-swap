// TODO:
// maybe distinguish initor&participant?
// maybe separate contract for tokens?

// https://github.com/lukem512/token-swap/blob/master/contracts/TokenSwap.sol

pragma solidity ^0.5.0;

contract ERC2266
{
    // enum Kind { Initiator, Participant }
    // enum InitiatorAssetState { Empty, Filled, Redeemed, Refunded }
    // enum ParticipantAssetState { Empty, Filled, Redeemed, Refunded }
    enum AssetState { Empty, Filled, Redeemed, Refunded }

    struct Swap {
        bytes32 secretHash;
        bytes32 secret;
        address payable initiator;
        address payable participant;
        // Kind kind;
        address tokenA;
        address tokenB;
        uint256 initiatorAssetValue;
        uint256 initiatorAssetRefundTimestamp;
        AssetState initiatorAssetState;
        uint256 participantAssetValue;
        uint256 participantAssetRefundTimestamp;
        AssetState participantAssetState;
        uint256 premiumValue;
        uint256 premiumRefundTimestamp;
        AssetState premiumState;
    }

    mapping(bytes32 => Swap) public swaps;

    event SetUp(
        bytes32 secretHash,
        address initiator,
        address participant,
        address tokenA,
        address tokenB,
        uint256 initiatorAssetValue,
        uint256 participantAssetValue,
        uint256 premiumValue
    );

    event Initiated(
        uint256 initiateTimestamp,
        bytes32 secretHash,
        address initiator,
        address participant,
        address initiatorAssetToken,
        uint256 initiatorAssetValue,
        uint256 assetRefundTimestamp,
    );

    event PremiumFilled(
        uint256 fillPremiumTimestamp,
        bytes32 secretHash,
        address initiator,
        address participant,
        address premiumToken,
        uint256 premiumValue,
        uint256 premiumRefundTimestamp
    );

    event Participated(
        uint256 participateTimestamp,
        bytes32 secretHash,
        address initiator,
        address participant,
        address participantAssetToken,
        uint256 participantAssetValue,
        uint256 participantAssetRefundTimestamp
    );

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

    // event PremiumRedeemed(
    //     uint256 redeemTimestamp,
    //     bytes32 secretHash,
    //     address redeemer,
    //     address token,
    //     uint256 value
    // );

    // event PremiumRefunded(
    //     uint256 refundTimestamp,
    //     bytes32 secretHash,
    //     address refunder,
    //     address token,
    //     uint256 value
    // );

    constructor() public {}

    // modifiers...

    modifier isInitiatorAssetEmptyState(bytes32 secretHash) {
        require(swaps[secretHash].initiatorAssetState == AssetState.Empty);
        _;
    }

    modifier isParticipantAssetEmptyState(bytes32 secretHash) {
        require(swaps[secretHash].participantAssetState == AssetState.Empty);
        _;
    }

    modifier isPremiumEmptyState(bytes32 secretHash) {
        require(swaps[secretHash].premiumState == AssetState.Empty);
        _;
    }

    modifier canSetup(bytes32 secretHash) {
        require(swaps[secretHash].initiatorAssetState == AssetState.Empty);
        require(swaps[secretHash].premiumState == AssetState.Empty);
        require(swaps[secretHash].participantAssetState == AssetState.Empty);
        _;
    }

    // TODO: maybe check balance?
    modifier canInitiate(bytes32 secretHash) {
        require(swaps[secretHash].initiator == msg.sender);
        require(swaps[secretHash].initiatorAssetState == AssetState.Empty);
        _;
    }

    // TODO: maybe check balance?
    modifier canFillPremium(bytes32 secretHash) {
        require(swaps[secretHash].initiator == msg.sender);
        require(swaps[secretHash].premiumState == PremiumState.Empty);
        _;
    }

    // TODO: maybe check balance?
    modifier canParticipate(bytes32 secretHash) {
        require(swaps[secretHash].participant == msg.sender);
        require(swaps[secretHash].participantAssetState == AssetState.Empty);
        require(swaps[secretHash].premiumState == PremiumState.Filled);
        _;
    }

    modifier checkRefundTimestampOverflow(uint256 refundTime) {
        uint256 refundTimestamp = block.timestamp + refundTime;
        require(refundTimestamp > block.timestamp, "calc refundTimestamp overflow");
        require(refundTimestamp > refundTime, "calc refundTimestamp overflow");
        _;
    }

    function setup(bytes32 secretHash,
                    address payable initiator,
                    address initiatorToken,
                    uint256 initiatorAssetValue,
                    address payable participant,
                    address participantToken,
                    uint256 participantAssetValue,
                    uint256 premiumValue)
        public
        payable
        canSetup(secretHash)
    {
        swaps[secretHash].secretHash = secretHash;
        swaps[secretHash].initiator = initiator;
        swaps[secretHash].initiatorToken = initiatorToken;
        swaps[secretHash].initiatorAssetValue = initiatorAssetValue;
        swaps[secretHash].initiatorAssetState = AssetState.Empty;
        swaps[secretHash].participant = participant;
        swaps[secretHash].participantToken = participantToken;
        swaps[secretHash].participantAssetValue = participantAssetValue;
        swaps[secretHash].participantAssetState = AssetState.Empty;
        swaps[secretHash].premiumValue = premiumValue;
        swaps[secretHash].premiumState = AssetState.Empty;
        
        emit SetUp(
            secretHash,
            initiator,
            initiatorToken,
            initiatorAssetValue,
            participant,
            participantToken,
            participantAssetValue,
            premiumValue
        );
    }

    // TODO: we also need approval, https://ethereum.stackexchange.com/questions/46318/how-can-i-transfer-erc20-tokens-from-a-contract-to-an-user-account
    // TODO: update balance?
    function initiate(bytes32 secretHash, uint256 assetRefundTime)
        public
        payable
        canInitiate(secretHash)
        checkRefundTimestampOverflow(assetRefundTime)
    {
        swaps[secretHash].tokenA.transferFrom(swaps[secretHash].initiator, address(this), swaps[secretHash].initiatorAssetValue);
        swaps[secretHash].initiatorAssetState = AssetState.Filled;
        swaps[secretHash].initiatorAssetRefundTimestamp = block.timestamp + assetRefundTime;
        
        emit Initiated(
            block.timestamp,
            secretHash,
            msg.sender,
            swaps[secretHash].participant,
            swaps[secretHash].tokenA,
            swaps[secretHash].initiatorAssetValue,
            swaps[secretHash].initiatorAssetRefundTimestamp,
        );
    }

    // Initiator needs to pay for the premium with premiumValue
    // TODO: we also need approval, https://ethereum.stackexchange.com/questions/46318/how-can-i-transfer-erc20-tokens-from-a-contract-to-an-user-account
    // TODO: update balance?
    function fillPremium(bytes32 secretHash, uint256 premiumRefundTime)
        public
        payable
        canFillPremium(secretHash)
        checkRefundTimestampOverflow(premiumRefundTime)
    {   
        swaps[secretHash].tokenB.transferFrom(swaps[secretHash].initiator, address(this), swaps[secretHash].premiumValue);
        swaps[secretHash].premiumState = AssetState.Filled;
        swaps[secretHash].premiumRefundTimestamp = block.timestamp + premiumRefundTime;
        
        emit PremiumFilled(
            block.timestamp,
            secretHash,
            msg.sender,
            swaps[secretHash].participant,
            swaps[secretHash].tokenB,
            swaps[secretHash].premiumValue,
            swaps[secretHash].premiumRefundTimestamp
        );
    }

    // TODO: we also need approval, https://ethereum.stackexchange.com/questions/46318/how-can-i-transfer-erc20-tokens-from-a-contract-to-an-user-account
    // TODO: update balance?
    function participate(bytes32 secretHash, uint256 assetRefundTime)
        public
        payable
        canParticipate(secretHash)
        checkRefundTimestampOverflow(assetRefundTime)
    {
        swaps[secretHash].tokenB.transferFrom(swaps[secretHash].participant, address(this), swaps[secretHash].participantAssetValue);
        swaps[secretHash].participantAssetState = AssetState.Filled;
        swaps[secretHash].participantAssetRefundTimestamp = block.timestamp + assetRefundTime;        
        
        emit Participated(
            block.timestamp,
            secretHash,
            swaps[secretHash].initiator,
            msg.sender,
            swaps[secretHash].tokenB,
            swaps[secretHash].participantAssetValue,
            swaps[secretHash].participantAssetRefundTimestamp
        );
    }
}
