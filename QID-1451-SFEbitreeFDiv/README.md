<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of QuantLet: SFEbitreeFDiv

Published in: Statistics of Financial Markets

Description: 'Computes European/American option prices using a binomial tree for assets with fixed amount dividends.'

Keywords: 'binomial, tree, asset, call, put, option, option-price, european-option, dividends, financial, black-scholes'

See also: SFEbitreePDiv, SFEbitreeCDiv, SFSbitreeNDiv

Author: Awdesch Melzer, Piotr Majer, Ying Chen

Author[Matlab]: Ying Chen

Submitted: Fri, June 13 2014 by Felix Jung

Input: 

- n: Number of Intervals

- k: Exercise Price

- i: Interest Rate

- t: Time to Expiration

- type: 0 is American, 1 is European

- tdiv: Time Point of Dividend Payoff

- sig: Volatility

- pdiv: Dividend in Currency Units

- flag: 1 is call, 0 is Put

- nodiv: Times of Dividend Payoff

- s0: Stock Price

Output: binomial trees and price of option

Example: 'User inputs parameters [s0, k, i, sig, t, n, type] like [230, 210, 0.04545, 0.25, 0.5, 5, 1], [flag (1 for call, 0 for put), nodiv, tdiv, pdiv] as [1, 2, 0.25, 0.25, 1, 1], then call price is shown.'

Example[Matlab]: 'User inputs the SFEbitreeCDiv parameters

```
