import numpy as np 

def calc_parameters(T, N, sigma, r, div):
    """
    Calculates the dependent parameters of the Binomial Tree (CRR)
    input:
      T     : time to maturity
      N     : number of steps of the tree
      sigma : volatility
      r     : interest rate 0.05 = 5%
      div   : cuntinuous dividend 0.03 = 3%
    output: 
      dt    : size of time step
      u     : factor of upwards movement of stock
      d     : factor of downwards movement of stock
      q     : risk-neutral probability
      b     : cost of carry
    """
    dt = T/N
    u = np.exp(sigma*np.sqrt(dt))
    d = 1/u
    b = r-div
    q = 1/2 + 1/2 * (b - 1/2 * sigma**2)*np.sqrt(dt)/sigma # P(up movement)
    return(dt, u, d, q, b)


def set_factor(t,t_div,div):
    """
    Determines the factor of dividend with which the stock is multiplied
    input:
      t      : current time
      div    : discrete dividend 0.03 = 3%
      t_div  : time point on which dividend is issued 
    output:
      factor with which the stock price is multiplied
    """
    if t>t_div : 
        factor = 1-div
    elif t<=t_div:
        factor = 1
    return factor


def calc_price(S0, K, u, d, N, r, dt, q, disc_div, disc_div_t, option):
    """
    Uses Backpropergation to calculate the option price of an European or 
    American option, saves the stock and option prices of the tree
    input:
      S0, K, u, d, N, r, dt, q: parameters of the Binomial Tree (CRR) Model
                                as in function calc_parameters      
      disc_div        : discrete dividend 0.03 = 3%
      disc_div_t      : time point when dividend is issued
      option          : 'Call', 'Put'
    output:
      asset_values    : The asset values from t=T to t=0 
      option_values   : The option values from t=T to t=0
      time_idx_values : Time step indices to the values above
      price           : price of the option
    """
    # calculate the values at maturity T
    # factor: 1-div for t > t_div, else: 1
    factor = set_factor(T, disc_div_t, disc_div)
    asset_values = factor * S0*(u**np.arange(N,-1,-1))*(d**np.arange(0,N+1,1))
    if option == 'Call':
        option_values = (np.maximum((asset_values-K),0)).tolist()
    elif option == 'Put':
        option_values = (np.maximum((K-asset_values),0)).tolist()
    asset_values = asset_values.tolist()

    #Using the recursion formula for pricing in the CRR model: 
    for n in np.arange(N-1,-1,-1):  # from (T-dt, T-2*dt, ...., dt, 0)
        factor = set_factor(n*dt, disc_div_t, disc_div)
        asset_val_temp = factor*(S0*(u**np.arange(n,-1,-1))*
                                 (d**np.arange(0,n+1,1)))
        option_val_temp =  (np.exp(-1*r*dt)
                            * (q*np.array(option_values[-(n+2):-1]) 
                               + (1-q)*np.array(option_values[-(n+1):])))
        asset_values += asset_val_temp.tolist()
        option_values += option_val_temp.tolist()
    
    price = option_values[-1]
    
    return asset_values, option_values, price


####### MAIN ################

S0     = 230      # current stock price
K      = 210      # strike price
T      = 0.50     # time to maturity
sigma  = 0.25     # volatility
r      = 0.04545  # interest rate
div    = 0        # continuous dividend
disc_div, disc_div_t = (0.01, 0.15)  # (div, t). after t: S(t)=(1-div_1)*S(t)
N      = 5        # steps in tree
option = 'Call'  

# calculate price 
dt, u, d, q, b = calc_parameters(T, N, sigma, r, div)
asset_values, option_values, price = calc_price(S0, K, u, d, N, 
                                                r, dt, q, 
                                                disc_div, disc_div_t, option)
print(price)
