# Input and solution

| Quantity | Value |
| :-- | --: |
| Capital V | 100,000.00 |
| Terminal floor F | 95,000.00 |
| Spot S0 | 100.00 |
| Maturity (years) | 2 |
| Rate r (continuous) | 10% |
| Volatility | 30% |
| Dividend yield q (continuous) | 2% |
| Solved strike K | 99.559927 |
| Put price P(K) | 8.720979 |
| Protected units F/K | 954.199173 |
| Initial portfolio cost | 100,000.00 |

# Newton convergence

| Iteration | Strike K | Put P(K) | Residual f(K) |
| --: | --: | --: | --: |
| 0 | 0.00100000 | 0.00000000 | 9.608e+01 |
| 1 | 91.27499672 | 6.06643371 | 6.066e+00 |
| 2 | 99.21002743 | 8.59815096 | 2.455e-01 |
| 3 | 99.55926292 | 8.72074521 | 4.650e-04 |
| 4 | 99.55992695 | 8.72097919 | 1.679e-09 |
| 5 | 99.55992695 | 8.72097919 | 0.000e+00 |

# Terminal scenarios

| Terminal stock price | Put payoff per unit | Protected terminal wealth |
| --: | --: | --: |
| 0.00 | 99.5599 | 95,000.00 |
| 60.00 | 39.5599 | 95,000.00 |
| 80.00 | 19.5599 | 95,000.00 |
| 100.00 | 0.0000 | 95,419.92 |
| 120.00 | 0.0000 | 114,503.90 |
| 140.00 | 0.0000 | 133,587.88 |
| 160.00 | 0.0000 | 152,671.87 |
