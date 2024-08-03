import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
import statistics
import math
# Load data from the first Excel
df = pd.read_excel('sa/best_solutions_new.xlsx')

# Load data from the second Excel (same number of rows as the first)
df_time = pd.read_excel('sa/solutions-time.xlsx')

# Setup plot
n_rows = 8
n_cols = 4
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
min_diffs = []  # List for storing the difference between min values and second column
true_values = []
# Process each row
for index, row in df.iterrows():
    values = row.values[2:]  # Exclude the first two columns
    true_value = row.values[1]  # This is the value from the second column
    true_values.append(true_value)
    variance = round(statistics.variance(values),2)
    mean = int(statistics.mean(values))
    min_value = min(values)
    max_value = max(values)
    
    instance_names.append(row.values[0][:-4])
    variances.append(variance)
    means.append(mean)
    min_values.append(min_value)
    max_values.append(max_value)
    min_diffs.append(min_value - true_value)  # Difference calculation

    # Adding time from the second Excel
    time = df_time.iloc[index, -1]  # Assumes the last column contains the 'time' data
    times.append(time)
    
    # Plotting
    axs[index].plot(range(3, len(values) + 3), values, linestyle='-', label=f'Variance: {variance:.2f}, Mean: {mean:.2f}')
    axs[index].plot(range(3, len(values) + 3), [true_value] * len(values), linestyle='-', label=f'True answer: {true_value}')
    axs[index].set_title(row.values[0][:-4])
    axs[index].grid(True)
    axs[index].legend()
    axs[index].yaxis.set_major_locator(MaxNLocator(integer=True))
    
    if index == (n_rows * n_cols) - 1:
        break

# Turn off unused axes
for i in range(index + 1, n_rows * n_cols):
    axs[i].axis('off')

# Save plot
plt.tight_layout()
plt.savefig("sa/variance.png")

# Create a DataFrame for statistics and save to Excel
stats_df = pd.DataFrame({
    'Instance Set': instance_names,
    'Optimal Solution':true_values,
    'Min': min_values,
    'Max': max_values,
    'Variance': variances,
    'Mean': means,
    'Gap': min_diffs,  # Adding the new column for min difference
    'Time': times
})
stats_df.to_excel('sa/statistics.xlsx', index=False)
