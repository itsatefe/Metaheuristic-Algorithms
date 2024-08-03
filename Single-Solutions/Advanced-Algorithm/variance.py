import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
import statistics

df = pd.read_excel('best_solutions_new.xlsx')
n_rows = 8
n_cols = 4
fig_width = n_cols * 6 
fig_height = n_rows * 3
fig, axs = plt.subplots(n_rows, n_cols, figsize=(fig_width, fig_height))
fig.subplots_adjust(hspace=0.4, wspace=0.4)
plots_created = 0
axs = axs.flatten()

for index, row in df.iterrows():
    values = row.values[2:]
    variance = statistics.variance(values)
    axs[index].plot(range(3, len(row.values) + 1), values, linestyle='-',label=f'Variance: {variance:.2f}')
    axs[index].plot(range(3, len(row.values) + 1), [row.values[1]] * (len(row.values) - 2), linestyle='-', label=f'true answer: {row.values[1]}')
    axs[index].set_title(row.values[0][:-4])
   
    axs[index].grid(True)
    axs[index].legend()
    axs[index].yaxis.set_major_locator(MaxNLocator(integer=True))
    
    plots_created += 1
    
    if index == (n_rows * n_cols) - 1:
        break

for i in range(plots_created, n_rows * n_cols):
    axs[i].axis('off')

plt.tight_layout()
plt.xlabel("Run")
plt.ylabel('Number of bins')
plt.savefig("Plots/variance.png")

