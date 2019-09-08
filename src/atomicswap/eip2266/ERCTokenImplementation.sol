contract ERC2266
{
    
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

    event SetUp(
        bytes32 secretHash,
        address initiator,
        address participant,
        uint256 assetValue,
        uint256 premiumValue
    );
}