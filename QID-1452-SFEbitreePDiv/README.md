<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of QuantLet: SFEbitreePDiv

Published in: Statistics of Financial Markets

Description: 'Computes European/American option prices using a binomial tree for assets with dividends as a percentage of the stock price amount.'

Keywords: 'binomial, tree, asset, call, put, option, option-price, european-option, dividends, financial, black-scholes'

See also: SFEbitreeFDiv, SFEbitreeCDiv, SFSbitreeNDiv

Author[R]: Awdesch Melzer, Ying Chen

Author[Matlab]: Ying Chen

Author[Python]: Franziska Wehrmann

Submitted[R]: Tue, December 03 2013 by Awdesch Melzer

Submitted[Python]: Thu, January 30 2020 by Franziska Wehrmann

Input: 

- i: Interest Rate

- n: Number of Intervals

- pdiv: Dividends as a percentage of the stock price amount

- nodiv: Times of Dividend Payoff

- tdiv: Time Point of Dividend Payoff

- s0: Stock Price

- t: Time to Expiration

- k: Exercise Price

- sig: Volatility

- flag: 1 is call, 0 is Put

- type: 0 is American, 1 is European

Output: binomial trees and price of option

Example[R]: 'User inputs parameters [s0, k, i, sig, t, n, type] like [230, 210, 0.04545, 0.25, 0.5, 5, 1], [flag (1 for call, 0 for put), nodiv, tdiv, pdiv] as [1, 1, 0.15, 0.01], then call price 28.3836 is shown.'

Example[Python]: 'Download .py file and run or copy-paste in jupyter notebook. Change variables in MAIN section of script (below definition of fuctions).'

```
