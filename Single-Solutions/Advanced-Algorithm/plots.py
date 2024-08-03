# %%
import matplotlib.pyplot as plt
import numpy as np
import sys
import os

dataset = sys.argv[1]


# %%
input_items = []

with open('InstanceSet1/'+dataset+'.txt', 'r') as file:
    for line in file:
        input_items.append(line[:-1])
items_count = int(input_items[0])
bin_capacity = int(input_items[1])
item_weights = [int(x) for x in input_items[2:]]

# %%

output_items = []
with open('Output/InstanceSet1/'+dataset+'_output.txt', 'r') as file:
    for line in file:
        output_items.append(line[:-1].split(' '))
bins_count = int(output_items[0][0])

# %%
bins_items = [[int(x) for x in sublist] for sublist in output_items[1:]]

# %%
if not os.path.exists("Plots/"+dataset):
    os.makedirs("Plots/"+dataset)
save_path1 = "Plots/"+dataset +"/visualization.png"


# %%
# Determine the grid size for the subplot arrangement
bins_per_row = 15
num_bins = len(bins_items)
num_rows = (num_bins + bins_per_row - 1) // bins_per_row  # Calculate required number of rows

# Create the figure with the adjusted subplot arrangement
fig, axes = plt.subplots(num_rows, bins_per_row, figsize=(50, num_rows * 4), squeeze=False)
axes = axes.flatten()  # Flatten the axes array for easy iteration

# Iterate over each bin to plot its items, now considering the new layout
for i, bin_items in enumerate(bins_items):
    ax = axes[i]
    base_point = 0  # Reset the base point for each bin
    
    for item in bin_items:
        weight = item_weights[item - 1]  # Get the weight of the item
        # Plot the item as a vertical rectangle
        ax.add_patch(plt.Rectangle((0.5, base_point), 0.4, weight, color=np.random.rand(3,)))
        # Place the item ID text
        ax.text(0.7, base_point + weight / 2, str(item), ha='center', va='center')
        
        base_point += weight  # Update the base point for stacking items

    ax.set_ylim(0, bin_capacity)  # Set the y-axis limit with some extra space
    ax.set_xticks([])  # Hide the x-ticks as they're not needed

# Hide any unused axes if the total number of bins is not a multiple of bins_per_row
for j in range(i + 1, len(axes)):
    axes[j].axis('off')

plt.tight_layout()
plt.savefig(save_path1)
plt.show()


# %%



