#!/usr/bin/python3
from datetime import datetime
import requests
import settings

headers = {'accept': 'application/json'}


def get_data(coin):
    url = "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=%s&days=365" % coin
    r = requests.get(url, headers)
    return r.json()


def main():
    for coin in settings.coin2s:
        print("Getting data of %s..." % coin)
        data = get_data(coin)
        print("Saving data for %s..." % coin)
        prices = data["prices"]
        last_timestamp = 0
        file = open(
            '../../data/exchange-rate/{}-{}.csv'.format(settings.coin1, coin), "w")
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
