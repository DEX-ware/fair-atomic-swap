import numpy as np
import math as m


def CRR(n, S, K, r, sigma_a, T, PC):
    '''
    n: steps of the binomial tree
    S: price
    K: strike price
    r: risk factor
    sigma_a: annualized volatility
    T: expiration time
    PC: type of the contract (0 for call, 1 for put)
    '''
    dt = T/n
    u = m.exp(sigma_a * m.sqrt(dt))
    d = 1/u
    p = (m.exp(r*dt)-d)/(u-d)
    Pm = np.zeros((n+1, n+1))
    Cm = np.zeros((n+1, n+1))
    tmp = np.zeros((2, n+1))
    for j in range(n+1):
        tmp[0, j] = S*m.pow(d, j)
        tmp[1, j] = S*m.pow(u, j)
    tot = np.unique(tmp)
    c = n
    for i in range(c+1):
        for j in range(c+1):
            Pm[i, j-c-1] = tot[(n-i)+j]
        c = c-1
    for j in range(n+1, 0, -1):
        for i in range(j):
            if (PC == 1):
                if(j == n+1):
                    Cm[i, j-1] = max(K-Pm[i, j-1], 0)
                else:
                    Cm[i, j-1] = m.exp(-.05*dt) * \
                        (p*Cm[i, j] + (1-p)*Cm[i+1, j])
            if (PC == 0):
                if (j == n + 1):
                    Cm[i, j-1] = max(Pm[i, j-1]-K, 0)
                else:
                    Cm[i, j-1] = m.exp(-.05*dt) * \
                        (p*Cm[i, j] + (1-p)*Cm[i+1, j])
    return [Pm, Cm]


if __name__ == '__main__':
    S = 100.0
    K = 100.0
    r = 0.05
    v = 0.3
    T = 20.0/36
    n = 17
    PC = 0
    Pm, Cm = CRR(n, S, K, r, v, T, PC)
    print('Pricing:\n', np.matrix(Pm.astype(int)))
    print('Option Values:\n', np.matrix(Cm.astype(int)))
