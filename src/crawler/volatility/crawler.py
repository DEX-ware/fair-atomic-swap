#!/usr/bin/python3
from datetime import datetime
import requests
import settings

headers = {'accept': 'application/json'}

def get_data(coin):
    url = "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=%s&days=365" %coin
    r = requests.get(url, headers)
    return r.json()

def main():
    for coin in settings.coins:
        print("Getting data of %s..." % coin)
        data = get_data(coin)
        print("Saving data of %s..." % coin)
        file = open('{}-{}.csv'.format(coin, datetime.today().strftime('%Y-%m-%d')), "w")
        try:
            file.write("")
            file.flush()
            file.close()
        except Exception as e:
            print("Error:", e)
    print("Done!")

if __name__ == '__main__':
    main()