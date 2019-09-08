// TODO:
// maybe distinguish initor&participant?
// maybe separate contract for tokens?

// ref:
// + https://ethereum.stackexchange.com/questions/46318/how-can-i-transfer-erc20-tokens-from-a-contract-to-an-user-account
// + https://theethereum.wiki/w/index.php/ERC20_Token_Standard

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

    event InitiatorAssetRedeemed(
        uint256 redeemTimestamp,
        bytes32 secretHash,
        bytes32 secret,
        address redeemer,
        address assetToken,
        uint256 value
    );

    event ParticipantAssetRedeemed(
        uint256 redeemTimestamp,
        bytes32 secretHash,
        bytes32 secret,
        address redeemer,
        address assetToken,
        uint256 value
    );

    event InitiatorAssetRefunded(
        uint256 refundTimestamp,
        bytes32 secretHash,
        address refunder,
        address assetToken,
        uint256 value
    );

    event ParticipantAssetRefunded(
        uint256 refundTimestamp,
        bytes32 secretHash,
        address refunder,
        address assetToken,
        uint256 value
    );

    event PremiumRedeemed(
        uint256 redeemTimestamp,
        bytes32 secretHash,
        address redeemer,
        address token,
        uint256 value
    );

    event PremiumRefunded(
        uint256 refundTimestamp,
        bytes32 secretHash,
        address refunder,
        address token,
        uint256 value
    );

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

    modifier isAssetRedeemable(bytes32 secretHash, bytes32 secret) {
        if (swaps[secretHash].initiator == msg.sender) {
            require(swaps[secretHash].initiatorAssetState == AssetState.Filled);
            require(block.timestamp <= swaps[secretHash].initiatorAssetRefundTimestamp);
        } else {
            require(swaps[secretHash].participant == msg.sender);
            require(swaps[secretHash].participantAssetState == AssetState.Filled);
            require(block.timestamp <= swaps[secretHash].participantAssetRefundTimestamp);
        }
        require(sha256(abi.encodePacked(secret)) == secretHash);
        _;
    }

    modifier isAssetRefundable(bytes32 secretHash) {
        if (swaps[secretHash].initiator == msg.sender) {
            require(swaps[secretHash].initiatorAssetState == AssetState.Filled);
            require(block.timestamp > swaps[secretHash].initiatorAssetRefundTimestamp);
        } else {
            require(swaps[secretHash].participant == msg.sender);
            require(swaps[secretHash].participantAssetState == AssetState.Filled);
            require(block.timestamp > swaps[secretHash].participantAssetRefundTimestamp);
        }
        _;
    }

    modifier isPremiumFilledState(bytes32 secretHash) {
        require(swaps[secretHash].premiumState == PremiumState.Filled);
        _;
    }

    // Premium is redeemable for Bob if Bob participates and redeem
    // before premium's timelock expires
    modifier isPremiumRedeemable(bytes32 secretHash) {
        // the participant invokes this method to redeem the premium
        require(swaps[secretHash].participant == msg.sender);
        // the premium should be deposited
        require(swaps[secretHash].premiumState == PremiumState.Filled);
        // if Bob participates, which means participantAsset will be: Filled -> (Redeemed/Refunded)
        require(swaps[secretHash].participantAssetState == AssetState.Refunded || swaps[secretHash].participantAssetState == AssetState.Redeemed);
        // the premium timelock should not be expired
        require(block.timestamp <= swaps[secretHash].premiumRefundTimestamp);
        _;
    }

    // Premium is refundable for Alice only when Alice initiates
    // but Bob does not participate after premium's timelock expires
    modifier isPremiumRefundable(bytes32 secretHash) {
        // the initiator invokes this method to refund the premium
        require(swaps[secretHash].initiator == msg.sender);
        // the premium should be deposited
        require(swaps[secretHash].premiumState == PremiumState.Filled);
        // asset2 should be empty
        // which means Bob does not participate
        require(swaps[secretHash].premiumState == AssetState.Empty);
        require(block.timestamp > swaps[secretHash].premiumRefundTimestamp);
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

    // Initiator needs to pay for the initiatorAsset(tokenA) with initiatorAssetValue
    // Initiator will also need to call tokenA.approve(this_contract_address, initiatorAssetValue) in advance
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

    // Initiator needs to pay for the premium(tokenB) with premiumValue
    // Initiator will also need to call tokenB.approve(this_contract_address, premiumValue) in advance
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

    // Participant needs to pay for the participantAsset(tokenB) with participantAssetValue
    // Participant will also need to call tokenB.approve(this_contract_address, participantAssetValue) in advance
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

    function redeemAsset(bytes32 secret, bytes32 secretHash)
        public
        isAssetRedeemable(secretHash, secret)
    {
        swaps[secretHash].secret = secret;
        if (swaps[secretHash].initiator == msg.sender) {
            swaps[secretHash].tokenB.transfer(msg.sender, swaps[secretHash].participantAssetValue);
            swaps[secretHash].participantAssetState = AssetState.Redeemed;

            emit ParticipantAssetRedeemed(
                block.timestamp,
                secretHash,
                secret,
                msg.sender,
                swaps[secretHash].tokenB,
                swaps[secretHash].participantAssetValue
            );
        } else {
            swaps[secretHash].tokenA.transfer(msg.sender, swaps[secretHash].initiatorAssetValue);
            swaps[secretHash].initiatorAssetState = AssetState.Redeemed;

            emit InitiatorAssetRedeemed(
                block.timestamp,
                secretHash,
                secret,
                msg.sender,
                swaps[secretHash].tokenA,
                swaps[secretHash].initiatorAssetValue
            );
        }
    }

    function refundAsset(bytes32 secretHash)
        public
        isPremiumFilledState(secretHash)
        isAssetRefundable(secretHash)
    {
        if (swaps[secretHash].initiator == msg.sender) {
            swaps[secretHash].tokenA.transfer(msg.sender, swaps[secretHash].initiatorAssetValue);
            swaps[secretHash].initiatorAssetState = AssetState.Refunded;

            emit InitiatorAssetRefunded(
                block.timestamp,
                secretHash,
                msg.sender,
                swaps[secretHash].tokenA,
                swaps[secretHash].initiatorAssetValue
            );
        } else {
            swaps[secretHash].tokenB.transfer(msg.sender, swaps[secretHash].participantAssetValue);
            swaps[secretHash].participantAssetState = AssetState.Refunded;

            emit ParticipantAssetRefunded(
                block.timestamp,
                secretHash,
                msg.sender,
                swaps[secretHash].tokenB,
                swaps[secretHash].participantAssetValue
            );
        }
    }

    function redeemPremium(bytes32 secretHash)
        public
        isPremiumRedeemable(secretHash)
    {
        swaps[secretHash].tokenB.transfer(msg.sender, swaps[secretHash].premiumValue);
        swaps[secretHash].premiumState = PremiumState.Redeemed;

        emit PremiumRefunded(
            block.timestamp,
            swaps[secretHash].secretHash,
            msg.sender,
            swaps[secretHash].tokenB,
            swaps[secretHash].premiumValue
        );
    }
    
    function refundPremium(bytes32 secretHash)
        public
        isPremiumRefundable(secretHash)
    {
        swaps[secretHash].tokenB.transfer(msg.sender, swaps[secretHash].premiumValue);
        swaps[secretHash].premiumState = PremiumState.Refunded;

        emit PremiumRefunded(
            block.timestamp,
            swaps[secretHash].secretHash,
            msg.sender,
            swaps[secretHash].tokenB,
            swaps[secretHash].premiumValue
        );
    }
}
