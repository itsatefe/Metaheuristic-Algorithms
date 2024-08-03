import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
import statistics

# Load data
df = pd.read_excel('aco/solutions_new.xlsx')

# Load additional data for 'time' column, assuming you have a similar setup
df_time = pd.read_excel('aco/solutions_time.xlsx')

# Setup plot
n_rows = 10
n_cols = 5
fig_width = n_cols * 6 
fig_height = n_rows * 3
fig, axs = plt.subplots(n_rows, n_cols, figsize=(fig_width, fig_height))
fig.subplots_adjust(hspace=0.4, wspace=0.4)
axs = axs.flatten()

# Initialize lists to store statistics
variances = []
means = []
instance_names = []
times = []
min_values = []
max_values = []
min_diffs = []
best_knowns = []
# Process each row
for index, row in df.iterrows():
    # Start extracting values from the fourth column (index 3)
    values = row.values[3:]
    if len(values) > 1:  # Ensure there are enough values to calculate variance
        variance = round(statistics.variance(values),2)
        mean = int(statistics.mean(values))
        min_value = min(values)
        best_known = row.values[1]
        max_value = max(values)
        if not pd.isna(row.values[2]):
            best_known = row.values[2]

        best_knowns.append(best_known)
        min_diff = min_value - best_known  # Difference between min and second column value


        instance_names.append(row.values[0])
        variances.append(variance)
        means.append(mean)
        min_values.append(min_value)
        max_values.append(max_value)
        min_diffs.append(min_diff)
        
        # Assume the time data is in the last column of df_time
        time = df_time.iloc[index, -1]
        times.append(int(time))

        axs[index].plot(range(4, len(values) + 4), values, linestyle='-', label=f'Variance: {variance:.2f}, Mean: {mean:.2f}')
        axs[index].plot(range(4, len(values) + 4), [best_known] * len(values), linestyle='-', label=f'Best Known: {best_known}')
        axs[index].set_title(row.values[0])
        axs[index].grid(True)
        axs[index].legend()
        axs[index].yaxis.set_major_locator(MaxNLocator(integer=True))
        
        if index == (n_rows * n_cols) - 1:
            break

for i in range(index + 1, n_rows * n_cols):
    axs[i].axis('off')

plt.tight_layout()
plt.savefig("aco/variance.png")

# Create a DataFrame for statistics and save to Excel
stats_df = pd.DataFrame({
    'Instance Set': instance_names,
    'Best Known Solution': best_knowns,
     'Min': min_values,
    'Max': max_values,
    'Variance': variances,
    'Mean': means,
    'Gap': min_diffs,
    'Time': times
})
stats_df.to_excel('aco/statistics.xlsx', index=False)
