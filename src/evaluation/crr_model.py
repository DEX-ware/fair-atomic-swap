import numpy as np
import math as m


def CRR(n, S_0, K, sigma_a, T, contract_type):
    '''
    The Cox-Ross-Rubinstein Model
    Please refer to https://en.wikipedia.org/wiki/Binomial_options_pricing_model
    Inputs:
        n: steps of the binomial tree
        S_0: initial asset price
        K: strike price
        sigma_a: annualized volatility
        T: strike time (in year)
        contract_type: type of the contract (0 for call, 1 for put)
    Returns:
        S_tree: The binomial tree of the asset prices
        C_tree: The binomial tree of the option prices
    '''

    # Step 1: Create the binomial price tree
    dt = T/n
    u = m.exp(sigma_a * m.sqrt(dt))
    d = 1/u
    # Following the risk neutral assumption, r = q
    # p = (m.exp((r-q)dt)-d)/(u-d) = (m.exp(0)-d)/(u-d)
    p = (m.exp(0)-d)/(u-d)
    q = 1-p

    S_tree = np.zeros((n+1, n+1))
    C_tree = np.zeros((n+1, n+1))

    # Step 1.5: Find the asset price for each node of the binomial price tree
    tmp = np.zeros((2, n+1))
    for j in range(n+1):
        tmp[0, j] = S_0 * m.pow(d, j)
        tmp[1, j] = S_0 * m.pow(u, j)
    tot = np.unique(tmp)
    c = n
    for i in range(c+1):
        for j in range(c+1):
            S_tree[i, j-c-1] = tot[(n-i)+j]
        c = c-1

    # Step 2+3: Find the option value of each node
    # starting from each final node
    for j in range(n+1, 0, -1):
        for i in range(j):
            if (contract_type == 1):
                if(j == n+1):
                    C_tree[i, j-1] = max(K-S_tree[i, j-1], 0)
                else:
                    C_tree[i, j-1] = m.exp(-q*dt) * \
                        (p*C_tree[i, j] + (1-p)*C_tree[i+1, j])
            if (contract_type == 0):
                if (j == n + 1):
                    C_tree[i, j-1] = max(S_tree[i, j-1]-K, 0)
                else:
                    C_tree[i, j-1] = m.exp(-q*dt) * \
                        (p*C_tree[i, j] + (1-p)*C_tree[i+1, j])

    # where the final estimated option price is C_tree[0][0]
    return S_tree, C_tree


def price(n, S_0, K, sigma_a, T, contract_type):
    _, C_tree = CRR(n, S_0, K, sigma_a, T, contract_type)
    return C_tree[0][0]


if __name__ == '__main__':
    # input
    S_0 = 100.0
    K = 100.0
    v = 0.3
    T = 20.0/36
    n = 17
    contract_type = 0

    # get all asset prices S_tree and option prices C_tree
    S_tree, C_tree = CRR(n, S_0, K, v, T, contract_type)
    print('Asset Prices:\n', np.matrix(S_tree.astype(int)))
    print('Option Prices:\n', np.matrix(C_tree.astype(int)))
    print('Final Price: ', price(n, S_0, K, r, v, T, contract_type))
