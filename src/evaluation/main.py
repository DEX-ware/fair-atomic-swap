import numpy as np
import pandas as pd
from datetime import datetime
import matplotlib
from matplotlib import pyplot as plt


def get_exchange_rate(coin1, coin2):
    filename = '../../data/exchange-rate/{}-{}_2019-05-02.csv'.format(
        coin1, coin2)
    df = pd.read_csv(filename,
                     index_col=['datetime'],
                     names=['datetime', 'price'])
    df.index = pd.to_datetime(df.index, unit='ms')
    return df


def annualized_volatility(df):
    daily_volatility = df['price'].std()
    annual_volatility = daily_volatility * np.sqrt(df['price'].size)
    return annual_volatility


if __name__ == '__main__':
    df = get_exchange_rate('btc', 'bch')
    print(annualized_volatility(df))
