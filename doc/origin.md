# [Lightning-dev] An Argument For Single-Asset Lightning Network

HTLCs as American Call Option, or, How Lightning Currently Cannot Work Across Assets, or, An Argument For Single-Asset Lightning Network

## Introduction


In theory, the Lightning Network could potentially perform "seamless" currency conversions, allowing a payer to spend one currency to pay a payee requesting for another currency.
However, a significant technical barrier prevents implementation of such feature as of current designs (late 2018) for Lightning.

The root cause of this significant technical barrier is the use of hashlocked timelocked contracts to route payments.
HTLCs can be used across cryptocurrency systems to transfer value between them.
>From this point-of-view, every single Lightning Network channel is a cryptocurrency system whose custodians are two entities, who are the only entities who can use the system (the single Lightning Network channel).
HTLCs allow cross-system trades to be performed, so that participation on any single Lightning Network channel can be leveraged to participation over the entire Lightning Network.

However, HTLCs can also be used to construct American Call Options.
Further, due to UX concerns, on the Lightning Network, there is no cost incurred in merely setting up HTLCs for routing.
By using the low-level HTLCs provided as primitives by Lightning Network, one can set up American Call Options.
These on-Lightning American Call Options, however, can be "purchased" for free (gratis), thus potentially earning money in a completely risk-free manner.
Abusing this gratis ability means that any Lightning Network node advertising cross-asset on-Lightning exchange will find large amounts of its liquidity tied up in stalled forwarding payments (in reality, American Call Options) with a risk of monetary loss in case of large fluctuations in exchange rate.

## Hashlocked Timelocked Contracts as American Call Options


An American CallOption is a right (but not obligation) to purchase an asset at a specific price, on or before an expiration date.
HTLCs allow building American Call Options.

Suppose we have Bitcoin, and some other asset, and both are on blockchains that support the same hash function and can define HTLCs.
It is unimportant if both are on the same blockchain, or on different blockchains, since HTLCs can work across cryptocurrency systems.

An American Call Option has these properties:

1.  `P` = the price at which the asset can be purchased.
2.  `E` = the date at which the option expires.

Suppose I, ZmnSCPxj, wanted to sell you an American Call Option  for 1 Widget (WJT) on the WJT blockchain.
We would then do the below ritual:

1.  You provide me a hash of some secret preimage that only you know.
2.  You make an HTLC on the Bitcoin blockchain.
    The value of this HTLC is `P`, the hash is the hash you gave above, and the timelock is `E` + 1 day.
3.  I make an HTLC on the WJT blockchain.
    The value of this HTLC is 1, the hash is the hash you gave, and the timelock is `E`.

On or before `E`, you can claim the WJT on the WJT blockchain by providing a transaction that reveals the preimage.
Since the preimage is now revealed, I can then claim the Bitcoins of price `P` on the Bitcoin blockchain.
Alternately, you can simply not exercise this right, and at time `E` I would then reclaim my WJT, and at time `E` + 1 day you would reclaim your bitcoins.

Of course, I want to *sell* this contract to you, so you would have to pay me some bitcoins before we set up the above.
A multi-stage construction of transactions that go through HTLC-like constructs can be done on both blockchains to ensure that the above contracts appear on both chains only if the payment for the actual contract (i.e. the "premium") is done, and to enforce that both contracts appear if the premium is paid, but that is beyond the scope of *this* writeup, which will focus on how Lightning Network HTLCs can form the above construction without any premium being paid.

## HTLCs For Routing


HTLCs can be used to enforce trades across different cryptocurrency systems.
This property is used to allow routing of payments across different channels.
Each channel is its own cryptocurrency system.

Suppose I, ZmnSCPxj, am an intermediate node on Lightning, and I wanted to sell you my service of facilitating payments on Lightning.
Suppose you want to pay to somebody, who, for the sake of convenience, we shall randomly call YAIjbOJA.
As it happens, I have a channel with you, and a channel with YAIjbOJa.

You need to pay YAIjbOJA `P` bitcoins.
We then perform the below ritual:

1.  YAIjbOJA provides you a hash, whose preimage only YAIjbOJA knows.
2.  On your channel with me, you set up an HTLC.
    The value is `P`+1 bitcoin (the 1 being my fee), the hash is the hash you were given, and the timelock is 2 days from now.
3.  On my channel with YAIjbOJA, I set up an HTLC.
    The value is `P`, the hash is the same hash as above, and the timelock is 1 day from now.

(in reality, the timelocks are parameterized and selected by the payer (you), and LN nodes will impose some "reasonable" limits on the timelocks; but the first HTLCs set up must have longer timelocks than the later HTLCs)

Afterward, YAIjbOJA may claim, or may not claim, the money in the HTLC by releasing (or not releasing) the hash to me.
If YAIjbOJA claims the money, then I can take the hash and claim the money, plus fee, from you.
If not, then this is a payment failure and I will then cancel the HTLC you offered using standard Lightning Network primitives.

In general, we expect that YAIjbOJA wants to have the money because every randomly-generated imaginary entity likes money.
Thus, in the case of payments, YAIjbOJA has a strong incentive to claim the money without waiting for the timelock to expire or nearly expire.
We can see that in practice, on the current Lightning Network, HTLCs are often very transient and will be quickly claimed, despite having long timelocks.

This speed may mislead us into thinking that such convenience may be possible across different assets.

## Cross-Asset Lightning Nodes Offer Premium-Free American Call Options


Suppose that Lightning Network supports multiple assets.
Each channel has a single asset.
Some nodes will advertise themselves as providing exchange capability, taking one asset on one channel and exchanging it for another asset on a different channel.

Suppose I advertise myself as such an exchange.
Suppose you want to pay to YAIjbOJA for 1 WJT, but have no WJT on hand to pay YAIjbOJA, only bitcoins.
As it happens, I have a bitcoin channel with you and a WJT channel with YAIjbOJA.
I advertise myself as exchanging `P` bitcoins for 1 WJT as of the current time.

Further suppose that in reality, YAIjbOJA is *you*, random Internet person reading my thoughts.

You, your fake persona YAIjbOJA, and me, then perform the following ritual:

1.  YAIjbOJA (really you) provides you with a hash whose preimage only YAIjbOJA (actually you) know. (i.e. you just make it up)
2.  On the bitcoin channel with me, you set up an HTLC.
    The value is `P`+1 bitcoin (the 1 being my fee), the hash is the hash that "YAIjbOJA" gave you (i.e. you really just made it up), and the timelock is 2 days from now.
3.  On the WJT channel with YAIjbOJA (really you), I set up an HTLC.
    The value is 1 WJT, the hash is the hash you gave me, and the timelock is 1 day from now.

The above is now the same as the setup for an American Call Option with expiration of 1 day from now.
Further, within certain limits, you can set up the expiration of the American Call Option to be longer or shorter.
Thus, I have inadvertently given you an American Call Option, for *no premium* (completely gratis), when my only intent was to facilitate cross-currency Lightning Network payments.

Suppose that the price of 1 WJT rises far above the price of `P`+1 bitcoins before the expiration (1 day from now).
In such a case, "YAIjbOJA" (really you) will then release the hash and acquire the 1 WJT.
You then close this channel and claim the WJT onchain, then sell it immediately to earn more than the `P`+1 bitcoins you paid.
Alternatively, presumably I would have a new exchange rate I would be willing to exchange WJT for, and you can just send the WJT with the new exchange rate immediately over the Lightning Network.

Suppose that the price of WJT does not rise.
Since this is an option and *not* a future, "YAIjbOJA" (really you) will simply claim that the payment errored somewhere and cancel the HTLCs.
Since even payment errors are not unwrappable and are onion-wrapped, I cannot determine whether the payment really errored, or you were just setting up an American Call Option that you have now decided not to exercise.

## Premium-free American Call Options Are Risk-free Earning Pumps


Traditionally, options are analyzed assuming that the option itself has a price, the premium.
This premium is the risk of the user of the option.
If the user of the option does not exercise the option before the expiration, then the premium is a pure loss of the user.

However, the above setup does not involve any payment when the option is not exercised.
Payment failures are "free" (gratis) on the Lightning Network.
However, payment failures are also the non-exercised branch of the American Call Option that can be set up on a cross-currency on-Lightning exchange.

Because the American Call Option is premium-free, even if the expiration is very near, rational entities will still construct such options.
Extreme volatility may occur in short time frames, especially in the realm of digital assets.

Thus, it is strongly likely that, if cross-asset exchange nodes on Lightning Network exist, they will be exploited to create risk-free American Call Options.
They will find that significant liquidity will be tied up in such American Call Options, and find that they will lose funds especially at times of volatility.

We can try to mitigate this, but the solutions below all have significant drawbacks.

1.  We could force that setting up the HTLCs requires payment.
    This forces the above American Call Options to have a premium.
    The effect, however, is that routing failure is not free.
    The current Lightning Network works despite not everyone publishing the balances of channels, precisely because routing failure is free.
    We only need to have one route succeed in order to actually successfully pay to the payee.
    With non-free routing failure, we cannot try many routes until one succeeds.
    * Suppose we limited this only to cross-asset exchanges.
      It would still require accurate knowledge of channel balances.
      This is because if a payment fails on a hop *after* the exchange, the payer still loses money from that attempt to the exchange node.
2.  Exchange nodes could increase their fees.
    This would create a wider "spread" of buying and selling assets.
    This spread would increase friction in crossing assets.
    Also, this would only reduce risk; if the exchange rate is volatile enough, then the option could still be exercised for riskless earnings.
    Rational entities will still tie up most of the liquidity on the exchange on riskless American Call Options; even if the exchange rate is very stable, they lose nothing.
3.  Exchange nodes could limit the timelock of cross-asset swaps.
    This would increase friction in crossing assets, since a timelock limit also imposes a limit to the route length.
    If one asset is much stronger than the other, then the weaker asset will find its part of the Lightning Network to be strongly centralized around the exchanges between the two assets.
    Payees of the weaker asset will strongly prefer to be at most one hop away from exchanges in order to viably receive payments from payers who are using the stronger asset.
    Again, rational entities will also still tie up most of the liquidity on the exchange on riskless American Call Options; again, even if the exchange rate is very stable in short time frames, they lose nothing anyway.

## Conclusion


HTLCs allow creation of American Call Options.
The same HTLCs are used in Lightning Network to route across channels.
If using a single asset, there is no issue related to time.
Regardless of the value of bitcoin relative to any other asset, in the future, 1 BTC is 1 BTC.

However, across assets, the ability of HTLCs to create American Call Options becomes troublesome.
These can then be exploited to earn money from exercise of the option.
Further, because Lightning UX would be degraded otherwise, payment failures are free (gratis), leading to the American Call Options also being free of premium.
This means that creating such options would be riskless, allowing potential earnings upon any strong volatility of exchange rates.

This implies that a multi-asset Lightning Network may not be economically viable.
Instead, Lightning Network would strongly prefer having a single asset across the network.
