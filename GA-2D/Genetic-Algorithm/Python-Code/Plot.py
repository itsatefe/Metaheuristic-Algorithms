import matplotlib.pyplot as plt
import matplotlib.patches as patches

# Define the dimensions of the bin
bin_width = 10
bin_height = 10

# Define the rectangles (width, height)
rectangles = [(3, 2), (4, 3), (3, 4), (2, 5), (2, 2)]

# Function to attempt to fit rectangles into the bin, filling from bottom-left row by row
def fit_rectangles(bin_width, bin_height, rectangles):
    placements = []
    used_space = [[0] * bin_height for _ in range(bin_width)]

    for (width, height) in rectangles:
        placed = False
        for x in range(bin_width - width + 1):
            if placed:
                break
            for y in range(bin_height - height, -1, -1):  # Start from the bottom of the bin
                # Check if space is free and fits the rectangle's height
                if all(not used_space[x + dx][y + dy] for dx in range(width) for dy in range(height)):
                    placements.append((x, y, width, height))
                    # Mark space as used
                    for dx in range(width):
                        for dy in range(height):
                            used_space[x + dx][y + dy] = 1
                    placed = True
                    break

                # If no space at the current level, move to the next column
                if y == 0:
                    break

    return placements

# Get placements of rectangles
placements = fit_rectangles(bin_width, bin_height, rectangles)

# Plotting
fig, ax = plt.subplots()
# Draw the bin
ax.add_patch(patches.Rectangle((0, 0), bin_width, bin_height, edgecolor='black', facecolor='none'))

# Draw the rectangles
for (x, y, width, height) in placements:
    ax.add_patch(patches.Rectangle((x, y), width, height, edgecolor='black', facecolor='blue', alpha=0.5))

ax.set_xlim(0, bin_width)
ax.set_ylim(0, bin_height)
ax.set_aspect('equal')
ax.set_title('2D Bin Packing Visualization')
plt.gca().invert_yaxis()  # Invert the y-axis to match the coordinate system
plt.show()
