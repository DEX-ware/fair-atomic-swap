# [bitcoin-dev] OP_LOOKUP_OUTPUT proposal

+ runchao and I
+ bip link in forked repo
+ purpose
    * try to solve [original link]
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

Here is a BIP draft brought up by Runchao and I to enable OP_LOOKUP_OUTPUT and thus to mitigate the arbitrage risk during an Atomic Swap. Basically the initior can abort the deal without receiving any penalty, see this(https://lists.linuxfoundation.org/pipermail/lightning-dev/2018-May/001292.html) and this(https://lists.linuxfoundation.org/pipermail/lightning-dev/2018-December/001752.html) for detail.

