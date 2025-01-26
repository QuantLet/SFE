<div style="margin: 0; padding: 0; text-align: center; border: none;">
<a href="https://quantlet.com" target="_blank" style="text-decoration: none; border: none;">
<img src="https://github.com/StefanGam/test-repo/blob/main/quantlet_design.png?raw=true" alt="Header Image" width="100%" style="margin: 0; padding: 0; display: block; border: none;" />
</a>
</div>

```
Name of QuantLet: SFEexerput

Published in: Statistics of Financial Markets

Description: Calculates the exercise price applying Newton''s method and gets the put option price using the Black Scholes model.

Keywords: Newton, black-scholes, european-option, exercise-price, financial, option, option-price, put

Author: Ying Chen

Author[Matlab]: Yanwu Wang, Ying Chen

Author[SAS]: Daniel T. Pele

Submitted: Fri, June 05 2015 by Lukas Borke

Submitted[Matlab]: Thu, April 28 2016 by Ya Qian

Submitted[SAS]: Thu, April 24 2014 by Petra Burdejova

Input: 
- t0 : Spot Date
- V : Capital
- F : Floor
- T : Expiration Date
- s0 : Spot Stock Price
- r : Continuous Interest Rate
- sig : Volatility
- d : Continuous Dividend

Output: 
- k : Exercise Price applying Newton Method
- pk : BS Put Option Price

Example: User inputs the parameters [Spot date, Capital, Floor, Expiration date] like [0, 100000, 95000, 2], and [Spot Stock Price, Continuous Interest Rate, Volatility, Continuous Dividend] like [100, 0.1, 0.3, 0.02] and gets the exercise price 99.56 and the BS put option price 8.72.

```
