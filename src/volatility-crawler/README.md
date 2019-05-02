# Volatility Crawler

This crawler crawls the BTC price volatility (vs. other TOP10 coins), in the past 12 months, ie, 2018/05/01 ~ 2019/05/01.

The data is stored in `/data/price_volatility`.

## Ref
+ https://apiv2.bitcoinaverage.com/#historical-data
+ https://medium.com/coinmonks/how-to-get-historical-crypto-currency-data-954062d40d2d
+ https://www.chainbits.com/tools-and-platforms/best-crypto-data-api/
+ https://www.coingecko.com/en/api#
+ https://www.coingecko.com/api/documentations/v3

## Prerequisite
+ virtualenv
+ py3
+ pip3 install bitcoinaverage
+ edit `$VIRTUAL_ENV/lib/python3.6/site-packages/`
    ```
    from itsdangerous import Signer, want_bytes
    from itsdangerous.signer import SigningAlgorithm
    ```
+ 