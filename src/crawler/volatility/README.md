# Volatility Crawler
This crawler crawls the BTC price volatility (vs. other TOP10 coins), in the past 12 months, ie, 2018/05/01 ~ 2019/05/01.

The data is stored in `<PROJ_ROOT_DIR>/data/price_volatility`.

## Ref
According to https://www.chainbits.com/tools-and-platforms/best-crypto-data-api/:
> if you are a data scientist in need of a lot of data this could be the API for you.

Moreover, after trying some services out and comparing across them, we've decided to pick __coingecko__.

+ https://www.coingecko.com/en/api#
+ https://www.coingecko.com/api/documentations/v3


## Prerequisite
+ virtualenv
+ python3
+ `pip3 install requests`