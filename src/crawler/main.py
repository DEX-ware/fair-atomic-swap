#!/usr/bin/python3
from datetime import datetime
import requests

headers = {'accept': 'application/json'}

# get coin list from https://api.coingecko.com/api/v3/coins/list
# TOP marketcap coins on 2019/May/02
coin1 = ['btc', 'bitcoin']
coin2s = ["eth", "xrp", "bch", "ltc", "eos", "bnb", "usd", "xlm"]


def get_exchange_rate(c1_full, c2):
    url = "https://api.coingecko.com/api/v3/coins/{}/market_chart?vs_currency={}&days=365".format(
        c1_full, c2)
    r = requests.get(url, headers)
    return r.json()


def main():
    for coin in coin2s:
        print("Getting data of %s..." % coin)
        data = get_exchange_rate(coin1[1], coin)
        print("Saving data for %s..." % coin)
        prices = data["prices"]
        last_timestamp = 0
        file = open(
            '../../data/exchange-rate/{}-{}.csv'.format(coin1[0], coin), "w")
        for price in prices:
            # price[0] is a timestamp and price[1] is the price at that time
            assert(price[0] > last_timestamp)
            last_timestamp = price[0]
            try:
                file.write('%d, %s\n' % (price[0], price[1]))
                file.flush()
            except Exception as e:
                print("Error:", e)
        file.close()
    print("Done!")


if __name__ == '__main__':
    main()
