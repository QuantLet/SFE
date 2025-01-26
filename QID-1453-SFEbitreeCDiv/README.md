<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of QuantLet: SFEbitreeCDiv

Published in: Statistics of Financial Markets

Description: Computes European/American option prices using a binomial tree for assets with/without continuous dividends.

Keywords: binomial, tree, asset, call, put, option, option-price, european-option, dividends, financial, black-scholes

See also: SFEbitreeFDiv, SFEbitreePDiv, SFSbitreeNDiv

Author[R]: Awdesch Melzer, Ying Chen

Author[Matlab]: Ying Chen

Author[Python]: Franziska Wehrmann

Submitted[R]: Tue, June 17 2014 by Thijs Benschop

Submitted[Python]: Thu, January 30 2020 by Franziska Wehrmann

Input: 
- i : Interest Rate
- type : 0 is American, 1 is European
- n : Number of Intervals
- k : Exercise Price
- t : Time to Expiration
- s0 : Stock Price
- sig : Volatility
- div : Contionous Dividend in Percentage
- flag : 1 is call, 0 is Put

Output: binomial trees and price of option

Example: User inputs parameters [s0, k, i, sig, t, n, type] like [230, 210, 0.04545, 0.25, 0.5, 5 ,0], [option (1 for call, 0 for put), continuous dividend in percentage (0 for no dividend)] as [1, 0.2], then call price is shown.

Example[Matlab]: User inputs the SFEbitreeCDiv parameters [s0, k, i, sig, t, n, type] like[230, 210, 0.04545, 0.25, 0.5, 5 ,0], [option (1 for call, 0 for put), continuous dividend in percentage (0 for no dividend)] as [1, 0.2], then American call price 21.4566 is shown. [s0, k, i, sig, t, n, type] like [1.5, 1.5, 0.09, 0.2, 0.33, 6 ,1], [option (1 for call, 0 for put), continuous dividend in percentage (0 for no dividend)] as [1, 0.02], then American call price 0.0836 is shown.

Example[python]: Download .py file and run or copy-paste in jupyter notebook. Change variables in MAIN section of script (below definition of fuctions).

```
<div align="center">
<img src="https://raw.githubusercontent.com/QuantLet/SFE/master/QID-1453-SFEbitreeCDiv/American_Put.png" alt="Image" />
</div>

