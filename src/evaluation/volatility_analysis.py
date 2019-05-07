from pathlib import Path
import pandas as pd
from parse import parse
import numpy as np
from matplotlib import pyplot as plt


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


if __name__ == '__main__':
    pairs = get_coin_pairs()
    for pair in pairs:
        c1, c2 = pair[0], pair[1]
        df = exchange_rate_csv_to_df(c1, c2)
        df['price_pct_change'].hist()
        plt.show()
        break
