# On the optionality and fairness of Atomic Swaps

This is the code of the paper [On the optionality and fairness of Atomic Swaps](https://eprint.iacr.org/2019/896) (to appear in [The First ACM Conference on Advances in Financial Technologies (AFT’19)](http://aft.acm.org)) by [Runchao Han](https://github.com/SebastianElvis), [Haoyu Lin](https://github.com/HAOYUatHZ) and [Jiangshan Yu](http://jiangshanyu.com).

## Directories

- `/data`: relevant experimental data
- `/doc`: relevant documentations
- `/paper`: source code of the paper
- `/src`: source code
  - `/src/atomicswap`: the Go code for launching Atomic Swaps with BTC and ETH
  - `/src/crawler`: a simple crawler for getting exchange rate data
  - `/src/evaluation`: code for evaluating the unfairness of Atomic Swaps, including the volatility analysis and the Cox-Ross-Rubinstein model
- `/test`: testing code for connecting BTC nodes

## Reference

Runchao Han, Haoyu Lin and Jiangshan Yu. On the optionality and fairness of Atomic Swaps. To appear in The First ACM Conference on Advances in Financial Technologies (AFT’19), Oct 2019.

## License

This code is licensed under GNU GPLv3.
