# [bitcoin-dev] OP_LOOKUP_OUTPUT proposal

Hi everybody!

Here is a BIP draft brought up by Runchao(CC'ed) and I to enable OP_LOOKUP_OUTPUT and thus to mitigate the arbitrage risk during an Atomic Swap using HTLC.

The problem can be simply decribed as that, the initior can abort the deal without receiving any penalty, see this(https://lists.linuxfoundation.org/pipermail/lightning-dev/2018-May/001292.html) and this(https://lists.linuxfoundation.org/pipermail/lightning-dev/2018-December/001752.html) for detail.

We have doned some research, including fetching cryptocurrency market history in the last year, and analyzing how profitable the arbitrage can be, given the default timelock setting (24/48 hrs) . Our result shows that the profit can be approximately 1% ~ 2.3%, which is non-negligible compared with 0.3% for stock market, and can be attractive considering it's risk-free.

A few studies have been put into efforts:

---

+ exchange article
+ thomas@eizinger.io
    * https://coblox.tech/docs/financial_crypto19.pdf
+ BIP197

But there still exists some problems:
xxxxxxxxx


We also find that an Atmoic Swap is indeed equivalent as an American Option without premium. And to , we integrate the premium mechanism into Atomic Swap.
Therefore, we bring up xxxxxxxxx


A sample implementation of XXX based on this opcode is here:
xxxxxxxxx


The BIP draft can be found here:
https://github.com/HAOYUatHZ/bips/blob/bip-lookup_output/bip-lookup_output.mediawiki


Some interesting features/ To conclude:
xxxxxxxxx