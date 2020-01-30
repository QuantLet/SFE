import numpy as np 
import matplotlib.pyplot as plt
plt.rcParams.update({'font.size': 16})
from matplotlib.lines import Line2D

def calc_parameters(T, N, sigma, r, div):
    """
    Calculates the dependent parameters of the Binomial Tree (CRR)
    input:
      T     : time to maturity
      N     : number of steps of the tree
      sigma : volatility
      r     : interest rate 0.05 = 5%
      div   : dividend 0.03 = 3%
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

def calc_price(S0, K, u, d, N, r, dt, q, type, option):
    """
    Uses Backpropergation to calculate the option price of an European or 
    American option, saves the stock and option prices of the tree
    input:
      S0, K, u, d, N, r, dt, q: parameters of the Binomial Tree (CRR) Model
                                as in function calc_parameters      
      type   : 'European', 'American'
      option : 'Call', 'Put'
    output:
      asset_values  : The asset values from t=T to t=0 
      option_values : The option values from t=T to t=0
      snell_values  : For American option: the values of the snell envelope 
                      For European option: None (snell envelope not needed)  
      time_values   : Time values to the values above
      price         : calculated option price
    """
    
    # calculate the values at maturity T
    asset_values = S0*(u**np.arange(N,-1,-1))*(d**np.arange(0,N+1,1))
    if option == 'Call':
        option_values = (np.maximum((asset_values-K),0)).tolist()
        snell_values = (np.maximum((asset_values-K),0)).tolist() 
    elif option == 'Put':
        option_values = (np.maximum((K-asset_values),0)).tolist()
        snell_values = (np.maximum((K-asset_values),0)).tolist() 


    asset_values = asset_values.tolist()

    #Using the recursion formula for pricing in the CRR model: 
    for n in np.arange(N-1,-1,-1):  # from (T-dt, T-2*dt, ...., dt, 0)
        asset_val_temp = (S0*(u**np.arange(n,-1,-1))*(d**np.arange(0,n+1,1)))

        if type == 'European':
            option_val_temp = (np.exp(-1*r*dt)
                *(q*np.array(option_values[-(n+2):-1])
                +(1-q)*np.array(option_values[-(n+1):])))
            
        elif type == 'American':
            if option == 'Call':
                option_val_temp = (np.exp(-1*r*dt)
                                   *(np.maximum((asset_val_temp-K),0)))
            elif option == 'Put':
                option_val_temp = (np.exp(-1*r*dt)
                                   *(np.maximum((K-asset_val_temp),0)))
            ex_tp1 = (np.exp(-1*r*dt)*(q*np.array(snell_values[-(n+2):-1])
                                      +(1-q)*np.array(snell_values[-(n+1):])))
            # decide for maximum
            snell_val_temp = np.maximum(option_val_temp, ex_tp1)
            snell_values += snell_val_temp.tolist()

            
        asset_values += asset_val_temp.tolist()
        option_values += option_val_temp.tolist()
    
    # create list of time values
    time_values = []
    for i in np.arange(N,-1,-1):
        time_values.extend([round(i*dt,2)]*(i+1))
    
    if type == 'European':
        price = option_values[-1]
        return asset_values, option_values, None, time_values, price
    
    elif type =='American':
        price = snell_values[-1]
        return asset_values, option_values, snell_values, time_values, price


def plot(asset_values, option_values, snell_values, time_values, type):
    """
    Creates a plot of the Binomial Tree. For American options the color of the
    point indicates, if the option is stopped early. red: stop, green: continue
    input:
      asset_values  : The asset values from t=T to t=0 
      option_values : The option values from t=T to t=0
      snell_values  : For American option: the values of the snell envelope 
                      For European option: None (snell envelope not needed)  
      time_values   : Time values to the values above
      type          : 'European', 'American'
    """
    
    plt.figure(figsize=(8,4.5))
    plt.subplot(111)
    plt.yscale('log')  
    mini=min(asset_values)/1.2
    maxi=max(asset_values)*1.2
    plt.ylim(mini,maxi)  
    plt.ylabel('Stock price (log-scale)')
    plt.xlabel('time')
    if type == 'European':
        plt.scatter(np.array(time_values),asset_values)
    elif type == 'American':
        color_array = np.array(snell_values)-np.array(option_values)
        col = np.where(color_array>0,'g','r')
        plt.scatter(np.array(time_values),asset_values, c=col)    
    
    # customize legend
    legend_elements = [Line2D([0], [0], marker='o', color='w', label='continue',
                          markerfacecolor='g', markersize=7),
                       Line2D([0], [0], marker='o', color='w', label='stop',
                          markerfacecolor='r', markersize=7)]
    plt.legend(handles=legend_elements)                   
    plt.tight_layout()
    #plt.savefig('American_Put.png', transparent=True)
    plt.show()

####### MAIN ################

S0 = 230
K = 210
T = 0.5
sigma = 0.25
r = 0.04545
div = 0.0
N = 100

# calculate all prices 
for option in ['Call', 'Put']:
    print(option)
    for type in ['European', 'American']:
        dt, u, d, q, b = calc_parameters(T, N, sigma, r, div)
        (asset_values, option_values, 
         snell_values, time_values, price) = calc_price(S0, K, u, d, N, r, 
                                                       dt, q, type, option)
        print('    ', type, price)

# plot tree of American Put
type = 'American'
option = 'Put'

dt, u, d, q, b = calc_parameters(T, N, sigma, r, div)
(asset_values, option_values, 
 snell_values, time_values, price) = calc_price(S0, K, u, d, N, r, 
                                                       dt, q, type, option)
print(price)
plot(asset_values, option_values, snell_values, time_values, type)

