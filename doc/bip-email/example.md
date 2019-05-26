# [bitcoin-dev] SIGHASH_ANYPREVOUT proposal

Anthony Towns aj at erisian.com.au 

Hi everybody!

Here is a followup BIP draft that enables SIGHASH_ANYPREVOUT and
SIGHASH_ANYPREVOUTANYSCRIPT on top of taproot/tapscript. (This is NOINPUT,
despite the name change)

I don't think we are (or should be) as confident that ANYPREVOUT is
ready for implementation and deployment as we are that taproot is.
In particular, we were still coming up with surprising ways that these
style of signatures could maybe cause problems over the past few months,
despite "NOINPUT" having been around for years, and having been thinking
seriously about it for most of the last year. In comparison we've had
a roughed out security proof for taproot [0] for over a year now.

So far, the best approach (in my opinion) that we've come up with to
limit the possible negative impacts of these types of signatures is to
require an additional regular signature to accompany every ANYPREVOUT
signature. As such, it's included in the BIP draft.

In theory this ensures that no ANYPREVOUT tx can cause any more problems
than some existing tx could; but in practice this assumes that the private
key for that signature is maintained in a similar way to the private keys
currently securing transactions are. After passing this around privately,
I'm not convinced the theory will survive meeting adversarial reality,
in which case I don't think this draft will be suitable for adoption.

But maybe I'm too pessimistic, or maybe we can come up with either
a proof that ANYPREVOUT is already safe without any other measures,
or maybe we can come up with some better measures to ensure it's safe.
So in any case I'm still hopeful that publishing the best we've got is
helpful, even if that still isn't good enough.

The BIP draft can be found here:
 https://github.com/ajtowns/bips/blob/bip-anyprevout/bip-anyprevout.mediawiki

A sample implementation based on the taproot branch is here:
 https://github.com/ajtowns/bitcoin/commits/anyprevout

Some interesting features:

 * This demonstrates how to upgrade tapscript's existing CHECKSIG,
   CHECKSIGADD and CHECKSIGVERIFY opcodes for new SIGHASH methods or
   potentially a new signature scheme, a new elliptic curve or other
   public key scheme
 * This demonstrates a cheap way of using the taproot internal key
   as the public key for CHECKSIG operations in script
 * There are two variants, ANYPREVOUT and ANYPREVOUTANYSCRIPT, which
   seems helpful for eltoo
 * The BIP attempts to describe the security implications of ANYPREVOUT-style
   signatures

Cheers,
aj

[0] https://github.com/apoelstra/taproot/blob/master/main.tex