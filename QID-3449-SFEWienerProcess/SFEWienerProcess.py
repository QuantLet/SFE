import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
sns.set_theme('notebook','white')

def SFEWienerProcess(dt, c, k):
    k = int(np.floor(k))
    if dt <= 0 or k <= 0:
        raise ValueError("Delta t and number of trajectories must be larger than 0!")
    
    l = 100
    n = int(np.floor(l / dt))
    t = np.arange(0, (n + 1) * dt, dt)  # n+1 points to match R output

    np.random.seed(0)
    z = np.random.rand(n, k)          # uniform (0,1)
    z = 2 * (z > 0.5) - 1             # convert to ±1
    z = z * c * np.sqrt(dt)           # scale steps

    zz = np.cumsum(z, axis=0)         # cumulative sum for each path
    x = np.vstack([np.zeros((1, k)), zz])  # add initial zeros like in R

    # Plot
    plt.figure(figsize=(12, 6))
    for i in range(k):
        plt.plot(t, x[:, i], linewidth=2)
    plt.title("Wiener process")
    plt.xlabel("Time t")
    plt.ylabel("Values of process $X_t$ delta")
    leg = plt.legend([f"path {i+1}" for i in range(5)], loc='lower center', bbox_to_anchor=(0.5, -0.2), ncol = 5, frameon = False)
    for item in leg.legendHandles:
        item.set_visible(False)
    c = [f'C{i}' for i in range(5)]
    for i,text in enumerate(leg.get_texts()) :
        text.set_color(c[i])
        text.set_size(15)

# Example usage
SFEWienerProcess(dt=0.5, c=1, k=5)

plt.savefig('./SFEWienerProcess_python', transparent = True, dpi = 200, bbox_inches = 'tight')