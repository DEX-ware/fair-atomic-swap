#!/usr/bin/python

from bitcoinaverage import RestfulClient

if __name__ == '__main__':
    public_key = 'your_public_key'
    secret_key = 'your_secret_key'

    restful_client = RestfulClient(secret_key, public_key)

    ticker_global_per_symbol = restful_client.ticker_global_per_symbol('BTCUSD')
    print('Global Ticker for BTCUSD:')
    print(ticker_global_per_symbol)