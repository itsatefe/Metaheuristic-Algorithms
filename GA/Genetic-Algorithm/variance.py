import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
import statistics

df = pd.read_excel('solutions_new.xlsx')
n_rows = 8
n_cols = 4
fig_width = n_cols * 6 
fig_height = n_rows * 3
fig, axs = plt.subplots(n_rows, n_cols, figsize=(fig_width, fig_height))
fig.subplots_adjust(hspace=0.4, wspace=0.4)
plots_created = 0
axs = axs.flatten()

for index, row in df.iterrows():
    # Start extracting values from the fourth column (index 3)
    values = row.values[3:]
    if len(values) > 1:  # Ensure there are enough values to calculate variance
        variance = statistics.variance(values)
        average = statistics.mean(values)
        axs[index].plot(range(4, len(row.values) + 1), values, linestyle='-', label=f'Variance: {variance:.2f}, Average: {average:.2f}')
        axs[index].plot(range(4, len(row.values) + 1), [row.values[1]] * (len(row.values) - 3), linestyle='-', label=f'True answer: {row.values[1]}')
        axs[index].set_title(row.values[0])
    
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
