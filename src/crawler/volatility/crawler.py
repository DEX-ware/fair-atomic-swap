#!/usr/bin/python3
import requests
import settings

headers = {'accept': 'application/json'}

def get_data(coin):
    url = "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=%s&days=365" %coin
    r = requests.get(url, headers)
    return r.json()

def main():
    for coin in settings.coins:
        data = get_data(coin)
        print(coin)
        print(data["prices"])
        print()

if __name__ == '__main__':
    main()