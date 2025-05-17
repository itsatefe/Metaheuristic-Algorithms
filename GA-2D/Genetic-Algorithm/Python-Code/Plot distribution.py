import numpy as np
import matplotlib.pyplot as plt






def read_items(file_path):
    from os.path import isfile
    full_path = file_path + ".ins2D"
    if not isfile(full_path):
        raise RuntimeError(f"Unable to open file: {file_path}")

    with open(full_path, 'r') as file:
        contents = file.read()

    lines = contents.splitlines()
    if len(lines) < 2:
        raise RuntimeError(f"File format error: missing item count or bin capacity in file: {file_path}")

    try:
        item_count = int(lines[0])
    except ValueError:
        raise RuntimeError("File format error: item count is not a valid integer")

    try:
        bin_width, bin_height = map(int, lines[1].split())
    except ValueError:
        raise RuntimeError("File format error: bin dimensions are not valid integers")

    items = []
    for id, line in enumerate(lines[2:item_count + 2], start=1):
        try:
            item_width, item_height = map(int, line.split())
            items.append({'id': id, 'width': item_width, 'height': item_height})
        except ValueError:
            raise RuntimeError(f"Invalid item dimensions at ID {id}")

    return {'bin_width': bin_width, 'bin_height': bin_height, 'items': items}

instance_name = "cl_09_100_05"
try:
    result = read_items("../InstanceSets/InstanceSet1/"+ instance_name)
    rectangles = result['items']
    bin_width = result['bin_width']
    bin_height = result['bin_height']
        
    n_samples = 1000
    item_size_ = len(rectangles) 
    total_area = 0
    for item in rectangles:
        total_area += (item['width'] * item['height'])
    
    min_bins = 53

    samples = [int((np.random.uniform(0, 1) ** 5) * (item_size_ - min_bins) + min_bins + 1) for _ in range(n_samples)]
    print(samples)
    plt.hist(samples, bins=50, density=True, alpha=0.7, color='blue')
    plt.title('Transformed Distribution ' + instance_name)
    plt.xlabel('Value')
    plt.ylabel('Density')
    plt.grid(True)


    plt.xticks(np.arange(min(samples), max(samples)+1, (max(samples) - min(samples))/10))
    plt.yticks(np.linspace(0, max(plt.hist(samples, bins=50, density=True)[0]), 10))
    plt.savefig(f"{instance_name}"+ "-bin-dist.png")
    # plt.show()


except RuntimeError as e:
    print(e)


import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D


def calculate_repair_probability(current_generation, max_generation, infeasible_count, population_size):
    # Using a smaller multiplier for a slower increase
    generation_factor = (-current_generation / float(max_generation)) * 1.5  # Smaller factor for slower increase
    return (1 - np.exp(generation_factor)) * (infeasible_count / float(population_size))

# Constants
population_size = 100
max_generation = 600
num_generations = 601  # Including generation 0

# Generate data
generations = np.linspace(0, max_generation, num_generations)
infeasible_counts = np.linspace(0, population_size, population_size + 1)

# Create meshgrid
X, Y = np.meshgrid(generations, infeasible_counts)
Z = calculate_repair_probability(X, max_generation, Y, population_size)

# Plot
fig = plt.figure(figsize=(12, 8))
ax = fig.add_subplot(111, projection='3d')
surf = ax.plot_surface(X, Y, Z, cmap='viridis')

# Labels and title
ax.set_xlabel('Generation')
ax.set_ylabel('Infeasible Count')
ax.set_zlabel('Repair Probability')
ax.set_title('Repair Probability Distribution')
fig.colorbar(surf)

# plt.show()
plt.savefig("repair_probability.png")


import numpy as np
import matplotlib.pyplot as plt

# Constants
population_size = 100
max_generation = 600
num_generations = 601

# Initialize arrays
infeasible_counts = np.zeros(num_generations)
probabilities = np.zeros(num_generations)

# Initial number of infeasible solutions
infeasible_counts[0] = 20  # Starting with a high number

# Simulation loop
for gen in range(1, num_generations):
    prob = calculate_repair_probability(gen, max_generation, infeasible_counts[gen-1], population_size)
    probabilities[gen] = prob
    # Assume a simple model where the probability directly reduces infeasible count
    infeasible_counts[gen] = max(0, infeasible_counts[gen-1] * (1 - prob))

# Plotting
plt.figure(figsize=(10, 6))
plt.subplot(2, 1, 1)
plt.plot(range(num_generations), probabilities, color='blue')
plt.title('Repair Probability Over Generations')
plt.ylabel('Probability')

plt.subplot(2, 1, 2)
plt.plot(range(num_generations), infeasible_counts, color='red')
plt.title('Infeasible Count Over Generations')
plt.ylabel('Count')
plt.xlabel('Generation')

plt.tight_layout()
plt.show()
