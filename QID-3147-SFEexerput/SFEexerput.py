"""Python adaptation of QuantLet QID-3147-SFEexerput (Ying Chen et al.).
Source: https://github.com/QuantLet/SFE/tree/master/QID-3147-SFEexerput
Solve exp(-q*tau)*S0 + P_BS(K) - (V/F)*K = 0.

Run: python SFEexerput.py --out results
Dependencies for plots: numpy, matplotlib. Pricing and solver use stdlib only.
The output includes transparent PNGs, vector SVGs and Markdown tables.
"""
from dataclasses import dataclass
from pathlib import Path
import argparse
import json
import math


@dataclass(frozen=True)
class Parameters:
    capital: float = 100_000.0
    floor: float = 95_000.0
    spot: float = 100.0
    rate: float = 0.10
    volatility: float = 0.30
    dividend_yield: float = 0.02
    tau: float = 2.0

    def validate(self):
        if not all(math.isfinite(v) for v in vars(self).values()):
            raise ValueError('All parameters must be finite.')
        if min(self.capital, self.floor, self.spot, self.volatility, self.tau) <= 0:
            raise ValueError('Capital, floor, spot, volatility and maturity must be positive.')
        # f(0+) > 0; f decreases strictly to -infinity under this condition.
        if self.capital / self.floor <= math.exp(-self.rate * self.tau):
            raise ValueError('No finite positive strike: require V/F > exp(-r*tau).')


def normal_cdf(x):
    """Stable normal CDF, including the lower tail."""
    return 0.5 * math.erfc(-x / math.sqrt(2.0))


def put_price(strike, p):
    """European Black-Scholes put with continuous dividend yield."""
    if strike <= 0:
        raise ValueError('Strike must be positive.')
    d1 = (math.log(p.spot / strike) +
          (p.rate - p.dividend_yield + 0.5 * p.volatility**2) * p.tau) / (
              p.volatility * math.sqrt(p.tau))
    d2 = d1 - p.volatility * math.sqrt(p.tau)
    return (strike * math.exp(-p.rate * p.tau) * normal_cdf(-d2)
            - p.spot * math.exp(-p.dividend_yield * p.tau) * normal_cdf(-d1))


def equation(strike, p):
    return (p.spot * math.exp(-p.dividend_yield * p.tau)
            + put_price(strike, p) - p.capital / p.floor * strike)


def derivative(strike, p):
    # The density terms in the original expanded derivative cancel exactly.
    d2 = (math.log(p.spot / strike) +
          (p.rate - p.dividend_yield - 0.5 * p.volatility**2) * p.tau) / (
              p.volatility * math.sqrt(p.tau))
    return math.exp(-p.rate * p.tau) * normal_cdf(-d2) - p.capital / p.floor


def solve_strike(p, initial=0.001, tolerance=1e-10, max_iterations=100):
    """Newton steps safeguarded by a positive sign-changing bracket.

    Stop on the equation residual, rather than the signed step in the R source.
    Recompute the put at the final strike (the source prints the previous put).
    """
    p.validate()
    if initial <= 0:
        raise ValueError('Initial strike must be positive.')
    lo = min(initial, p.spot) * 1e-6
    while equation(lo, p) <= 0:
        lo *= 0.1
        if lo == 0:
            raise ArithmeticError('Unable to establish lower strike bracket.')
    hi = max(initial, p.spot)
    for _ in range(100):
        if equation(hi, p) < 0:
            break
        hi *= 2
    else:
        raise ArithmeticError('Unable to establish upper strike bracket.')
    strike = min(max(initial, lo), hi)
    rows = []
    for iteration in range(max_iterations + 1):
        residual = equation(strike, p)
        rows.append(dict(iteration=iteration, strike=strike,
                         put=put_price(strike, p), residual=residual))
        if abs(residual) <= tolerance:
            return strike, rows
        if residual > 0:
            lo = strike
        else:
            hi = strike
        candidate = strike - residual / derivative(strike, p)
        strike = candidate if lo < candidate < hi else (lo + hi) / 2
    raise ArithmeticError('Newton method did not converge.')


def validate_solution(strike, p):
    """Independent bisection and economic identities check the numerical result."""
    lo, hi = 1e-10, max(2 * strike, p.spot)
    while equation(hi, p) > 0:
        hi *= 2
    for _ in range(150):
        mid = (lo + hi) / 2
        if equation(mid, p) > 0:
            lo = mid
        else:
            hi = mid
    if abs(strike - (lo + hi) / 2) > 1e-7:
        raise ArithmeticError('Independent bisection disagrees with Newton.')
    put = put_price(strike, p)
    n = p.floor / strike
    cost = n * (p.spot * math.exp(-p.dividend_yield * p.tau) + put)
    if abs(cost - p.capital) > 1e-5 or abs(n * strike - p.floor) > 1e-7:
        raise ArithmeticError('Portfolio budget or floor identity failed.')
    return put, n, cost


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--out', type=Path, default=Path('results'))
    args = parser.parse_args()
    args.out.mkdir(parents=True, exist_ok=True)
    p = Parameters()
    strike, rows = solve_strike(p)
    put, n, cost = validate_solution(strike, p)
    result = dict(parameters=vars(p), strike=strike, put_price=put,
                  protected_units=n, prepaid_stock_cost_per_unit=p.spot*math.exp(-p.dividend_yield*p.tau),
                  initial_portfolio_cost=cost, minimum_terminal_value=n*strike,
                  equation_residual=equation(strike,p), convergence=rows)
    (args.out / 'results.json').write_text(json.dumps(result, indent=2))
    summary = ('| Quantity | Value |\n| :-- | --: |\n'
               f'| Capital V | {p.capital:,.2f} |\n| Terminal floor F | {p.floor:,.2f} |\n'
               f'| Spot S0 | {p.spot:.2f} |\n| Maturity (years) | {p.tau:g} |\n'
               f'| Rate r (continuous) | {p.rate:.0%} |\n| Volatility | {p.volatility:.0%} |\n'
               f'| Dividend yield q (continuous) | {p.dividend_yield:.0%} |\n'
               f'| Solved strike K | {strike:.6f} |\n| Put price P(K) | {put:.6f} |\n'
               f'| Protected units F/K | {n:.6f} |\n| Initial portfolio cost | {cost:,.2f} |\n')
    convergence = '| Iteration | Strike K | Put P(K) | Residual f(K) |\n| --: | --: | --: | --: |\n'
    for row in rows:
        convergence += f"| {row['iteration']} | {row['strike']:.8f} | {row['put']:.8f} | {row['residual']:.3e} |\n"
    scenarios = '| Terminal stock price | Put payoff per unit | Protected terminal wealth |\n| --: | --: | --: |\n'
    for st in [0, 60, 80, 100, 120, 140, 160]:
        scenarios += f'| {st:.2f} | {max(strike-st,0):.4f} | {n*max(st,strike):,.2f} |\n'
    (args.out / 'tables.md').write_text('# Input and solution\n\n' + summary + '\n# Newton convergence\n\n' + convergence + '\n# Terminal scenarios\n\n' + scenarios)
    import numpy as np
    import matplotlib
    matplotlib.use('Agg')
    import matplotlib.pyplot as plt
    plt.rcParams.update({'font.family':'serif', 'mathtext.fontset':'cm', 'font.size':14})
    def save(fig, name):
        fig.tight_layout()
        fig.savefig(args.out / (name + '.png'), dpi=220, transparent=True)
        fig.savefig(args.out / (name + '.svg'), transparent=True)
        plt.close(fig)
    grid = np.linspace(40,160,400)
    fig, ax = plt.subplots(figsize=(9,5))
    ax.plot(grid,[equation(k,p) for k in grid], color='#165B88',lw=2)
    ax.axhline(0,color='#444444',lw=0.8)
    ax.plot(strike,0,'o',color='#B7202B',ms=7)
    ax.set(xlabel=r'Strike $K$', ylabel=r'$f(K)=S_0 e^{-q\tau}+P(K)-(V/F)K$')
    ax.grid(alpha=.15)
    save(fig, 'strike_equation')
    st = np.linspace(0,160,401)
    fig, ax = plt.subplots(figsize=(9,5))
    ax.plot(st,n*st,color='#777777',lw=1.5,ls='--')
    ax.plot(st,n*np.maximum(st,strike),color='#165B88',lw=2.5)
    ax.set(xlabel=r'Terminal stock price $S_T$',ylabel='Terminal portfolio value',xlim=(0,160),ylim=(0,n*160*1.04))
    ax.ticklabel_format(axis='y',style='plain')
    ax.grid(alpha=.15)
    save(fig, 'protected_payoff')
    print(summary)
    print(convergence)


if __name__ == '__main__':
    main()
