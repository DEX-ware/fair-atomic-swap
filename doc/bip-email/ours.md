# [bitcoin-dev] OP_LOOKUP_OUTPUT proposal

+ purpose
    * why itz important
        - how profitable can it be
            + maybe attach data
        - explain optionality and premium
+ related work
    * exchange article
    * BIP197
    * thomas@eizinger.io
        - https://coblox.tech/docs/financial_crypto19.pdf
+ example usage
    * spot
    * american option

---

Hi everybody!

Here is a BIP draft brought up by Runchao(CC'ed) and I to enable OP_LOOKUP_OUTPUT and thus to mitigate the arbitrage risk during an Atomic Swap using HTLC.

The problem can be simply decribed as that, the initior can abort the deal without receiving any penalty, see this(https://lists.linuxfoundation.org/pipermail/lightning-dev/2018-May/001292.html) and this(https://lists.linuxfoundation.org/pipermail/lightning-dev/2018-December/001752.html) for detail.

....


The BIP draft can be found here:
 https://github.com/HAOYUatHZ/bips/blob/bip-lookup_output/bip-lookup_output.mediawiki