# [bitcoin-dev] OP_LOOKUP_OUTPUT proposal

Hi everybody!

Here is a BIP draft brought up by Runchao(CC'ed) and I to enable OP_LOOKUP_OUTPUT and thus to mitigate the arbitrage risk during an Atomic Swap using HTLC.

The problem can be simply decribed as that, the initior can abort the deal, i.e., have optionality, without receiving any penalty. See this(https://lists.linuxfoundation.org/pipermail/lightning-dev/2018-May/001292.html) and this(https://lists.linuxfoundation.org/pipermail/lightning-dev/2018-December/001752.html) for detail.

We have doned some research, including fetching cryptocurrency market history in the last year, and analyzing how profitable the arbitrage can be, given the default timelock setting (24/48 hrs) . Our result shows that the profit can be approximately 1% ~ 2.3%, which is non-negligible compared with 0.3% for stock market, and can be attractive considering it's risk-free.

For better understanding, you may also refer to: 

+ https://en.bitcoin.it/wiki/Atomic_swap#Financial_optionality
+ https://blog.bitmex.com/atomic-swaps-and-distributed-exchanges-the-inadvertent-call-option/

A few studies have been put into efforts, e.g., http://diyhpl.us/wiki/transcripts/scalingbitcoin/tokyo-2018/atomic-swaps/ and https://coblox.tech/docs/financial_crypto19.pdf

However, there still exists some problems. Atmoic Swap can be used in Spot and Option. Coblox's solution is a fix for Spot but not for Option.

To solve this, we introduce the premium mechanism into Atomic Swap. __To acheive this, we need to__
Therefore, we propose the new opcode: OP_LOOKUP_OUTPUT. __TO....__   __THE reason why__


A sample implementation of Atmoic Swap for Spot based on this opcode is:
```
ScriptSig:
    Redeem: <Bob_sig> <Bob_pubkey> 1
    Refund: <Alice_sig> <Alice_pubkey> 0
ScriptPubKey:
    OP_IF // Normal redeem path
        // the owner of <asset2_output> should be Alice
        // which means Alice has redeemed asset2
        <asset2_output> OP_LOOKUP_OUTPUT <Alice_pubkeyhash> OP_EQUALVERIFY 
        OP_DUP OP_HASH160 <Bob_pubkeyhash>
    OP_ELSE // Refund path
        // the premium timelock should be expired
        <locktime> OP_CHECKLOCKTIMEVERIFY OP_DROP
        OP_DUP OP_HASH160 <Alice pubkey hash>
    OP_ENDIF
    OP_EQUALVERIFY
    OP_CHECKSIG
```

A sample implementation of Atmoic Swap for Option based on this opcode is here:
```
ScriptSig:
    Redeem: <Bob_sig> <Bob_pubkey> 1
    Refund: <Alice_sig> <Alice_pubkey> 0
ScriptPubKey:
    OP_IF // Normal redeem path
        // the owner of the asset2 should not be the contract
        // it should be either (redeemde by) Alice or (refunded by) Bob
        // which means Alice has redeemed asset2
        <asset2_output> OP_LOOKUP_OUTPUT <Alice_pubkeyhash> OP_NUMEQUAL
        <asset2_output> OP_LOOKUP_OUTPUT <Bob_pubkeyhash> OP_NUMEQUAL
        OP_ADD 1 OP_NUMEQUALVERIFY
        OP_DUP OP_HASH160 <Bob_pubkeyhash>
    OP_ELSE // Refund path
        // the premium timelock should be expired
        <locktime> OP_CHECKLOCKTIMEVERIFY OP_DROP
        OP_DUP OP_HASH160 <Alice pubkey hash>
    OP_ENDIF
    OP_EQUALVERIFY
    OP_CHECKSIG
```


The BIP draft can be found here:
https://github.com/HAOYUatHZ/bips/blob/bip-lookup_output/bip-lookup_output.mediawiki

To conclude, in order to avoid the risk-free optionality in Atomic Swap, we propose a new opcode OP_LOOKUP_OUTPUT, using premium to mitigate the risk of Atomic Swap both in Spot and in Option.