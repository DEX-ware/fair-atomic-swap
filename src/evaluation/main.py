import numpy as np
import pandas as pd
from datetime import datetime
from pathlib import Path
from parse import parse
import matplotlib
from matplotlib import pyplot as plt
from crr_model import price


exchange_rate_dir = Path('../../data/exchange-rate/')


def get_coin_pairs():
    pairs = []
    for x in exchange_rate_dir.iterdir():
        if x.is_file():
            c1, c2 = parse('{}-{}.csv', x.name)
            pairs.append([c1, c2])
    return pairs


def exchange_rate_csv_to_df(coin1, coin2):
    filename = exchange_rate_dir / '{}-{}.csv'.format(
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
    df = exchange_rate_csv_to_df(bob_coin, alice_coin)
    sigma_a = annualized_volatility(df)

    print('Alice: {}, Bob: {}, Amount of alice_coin: {}, Amount of bob_coin: {}, sigma_a: {}, '.format(
        alice_coin, bob_coin, bob_coin_amount * df['price'][-1], bob_coin_amount, sigma_a), end='')

    # money_in_alice_coin = bob_coin_amount * bob_coin / alice_coin
    p = price(12, df['price'][0] * bob_coin_amount,
              df['price'][0] * bob_coin_amount, sigma_a, 1.0, 0)

    print('Option price: {} alice_coin'.format(p))
    return p


if __name__ == '__main__':
    pairs = get_coin_pairs()
    for pair in pairs:
        c1, c2 = pair[0], pair[1]
        for a in np.arange(10, 100, 10):
            price_atomic_swap(c2, c1, a)
        print()
