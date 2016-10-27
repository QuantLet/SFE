
# clear variables and close windows
rm(list = ls(all = TRUE))
graphics.off()

# parameter settings
K   = 800     # Strike Price
S   = 750     # Spot Price
r   = 0.1     # Interest Rate
tau = 0.8     # Remaining Time
P   = 5.4     # Price of European Put
D   = 2       # Value of all Earnings and Costs Related to Underlying

ValNames = c("Strike Price (K) =", "Spot Price (S) =", "Interest Rate (r) =", "Remaining Time (tau) =", 
    "Price of European Put (P) =", "Earnings and Costs Related to Underlying (D)=")
def = c(K, S, r, tau, P, D)
v = data.frame(def, row.names = ValNames)

K   = v[1, ]  # Alternatively K   = v['Strike Price (K) =',]
S   = v[2, ]  # Alternatively S   = v['Spot Price (S) =',]
r   = v[3, ]  # Alternatively r   = v['Interest Rate (r) =',]
tau = v[4, ]  # Alternatively tau = v['Remaining Time (tau) =',]
P   = v[5, ]  # Alternatively P   = v['Price of European Put (P) =',]
D   = v[6, ]  # Alternatively D   = v['Earnings and Costs Related to Underlying (D)=',]

C = P - K * exp((-1) * r * tau) + S - D

ifelse((P >= max(K * exp((-1) * r * tau) - S + D, 0)) & (P <= K), paste("Price of the European Call =", 
    round(C, digits = 2)), paste("SFEPutCall: General arbitrage inequality is not satisfied!"))