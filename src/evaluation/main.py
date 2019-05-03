import numpy as np
import pandas as pd
from datetime import datetime
import matplotlib
from matplotlib import pyplot as plt
from crr_model import price


def get_exchange_rate(coin1, coin2):
    filename = '../../data/exchange-rate/{}-{}.csv'.format(
        coin1, coin2)
    df = pd.read_csv(filename,
                     index_col=['datetime'],
                     names=['datetime', 'price'])
    df.index = pd.to_datetime(df.index, unit='ms')
    df['price_pct_change'] = df['price'].pct_change()
    return df


def annualized_volatility(df):
    daily_volatility = df['price_pct_change'].std()
    annual_volatility = daily_volatility * np.sqrt(df['price'].size)
    return annual_volatility


def price_atomic_swap(alice_coin, bob_coin, bob_coin_amount):
    # exchange rate of bob_coin / alice_coin
    df = get_exchange_rate(bob_coin, alice_coin)
    sigma_a = annualized_volatility(df)

    print('Alice: {}, Bob: {}, Amount of alice_coin: {}, Amount of bob_coin: {}, sigma_a: {}, '.format(
        alice_coin, bob_coin, bob_coin_amount * df['price'][-1], bob_coin_amount, sigma_a), end='')

    # money_in_alice_coin = bob_coin_amount * bob_coin / alice_coin
    try:
        p = price(12, df['price'][0] * bob_coin_amount,
                  df['price'][0] * bob_coin_amount, 0.05, sigma_a, 1.0, 0)
    except OverflowError as e:
        p = np.NaN

    print('Option price: {} alice_coin'.format(p))
    return p


if __name__ == '__main__':
    coin1 = 'btc'
    coin2s = ["eth", "xrp", "bch", "ltc", "eos", "bnb", "usd", "xlm"]

    for c in coin2s:
        for a in np.arange(10, 100, 10):
            price_atomic_swap(c, coin1, a)
        print()
