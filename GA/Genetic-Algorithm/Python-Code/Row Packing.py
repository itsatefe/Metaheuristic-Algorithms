import matplotlib.pyplot as plt
import matplotlib.patches as patches
import matplotlib.colors as mcolors


import random

class Bin:
    def __init__(self, width, height):
        self.width = width
        self.height = height
        self.rows = []
        self.current_y = 0

    def add_rectangle(self, rectangle):
        width, height = rectangle
        if self.rows and self.rows[-1]['width_used'] + width <= self.width:
            row = self.rows[-1]
        else:
            if self.current_y + height > self.height:
                return False
            row = {'width_used': 0, 'rectangles': [], 'y_position': self.current_y}
            self.rows.append(row)
            self.current_y += height

        row['rectangles'].append((rectangle, (row['width_used'], row['y_position'])))
        row['width_used'] += width
        return True

def visualize_bins(bins, file_name):
    num_bins = len(bins)
    cols = min(5, num_bins)  # Up to 5 bins per row
    rows = (num_bins + cols - 1) // cols  # Calculate how many rows are needed

    fig, axs = plt.subplots(rows, cols, figsize=(cols * 4, rows * 3))
    if num_bins == 1:
        axs = [axs]  # Make it iterable if there's only one subplot
    axs = axs.flatten()  # Flatten the array to simplify indexing

    # Generate a color palette using a colormap
    cmap = plt.get_cmap('tab20')  # This colormap has 20 unique colors
    colors = cmap.colors

    for idx, bin in enumerate(bins):
        ax = axs[idx]
        ax.set_title(f"Bin {idx + 1}")
        ax.set_xlim(0, bin.width)
        ax.set_ylim(0, bin.height)
        color_index = 0

        for row in bin.rows:
            for rect, position in row['rectangles']:
                x, y = position
                width, height = rect
                color = colors[color_index % len(colors)]  # Cycle through colors if more than 20 items
                rect_patch = patches.Rectangle((x, y), width, height, linewidth=1, edgecolor='black', facecolor=color)
                ax.add_patch(rect_patch)
                color_index += 1  # Move to next color

        ax.set_aspect('equal')
        ax.grid(True)

    for idx in range(num_bins, len(axs)):  # Hide unused subplots
        axs[idx].axis('off')

    plt.tight_layout()
    plt.savefig(file_name)
    plt.close(fig)

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


def row_packing_with_randomization(rectangles, bin_width, bin_height):


    bins = []
    leftover_items = []

    while rectangles:
        if not rectangles:  # No more new items to select from
            current_batch = leftover_items
            leftover_items = []
        else:
            N = random.randint(0, min(10, len(rectangles)))  # Example: N can be between 1 and 10
            current_batch = random.sample(rectangles, N)
            for item in current_batch:
                rectangles.remove(item)  # Remove selected items from the main list

        current_batch.sort(key=lambda x: (x['height'], x['width']), reverse=True)

        new_bin = Bin(bin_width, bin_height)
        current_fits = []

        for item in current_batch:
            if not new_bin.add_rectangle((item['width'], item['height'])):
                leftover_items.append(item)
            else:
                current_fits.append(item)

        if current_fits:  # Only add the bin if at least one item fits
            bins.append(new_bin)

        rectangles.extend(leftover_items)
        leftover_items = []
        
    return bins

    bins = []
    rectangles.sort(key=lambda x: x[1], reverse=True)  # Sort by height descending

    for rectangle in rectangles:
        placed = False
        for bin in bins:
            if bin.fits_in_current_row(rectangle[0]):
                bin.add_rectangle(rectangle)
                placed = True
                break
        if not placed:
            # Create new bin if it doesn't fit in any existing bins
            new_bin = Bin(bin_width)
            new_bin.add_rectangle(rectangle)
            bins.append(new_bin)

    return bins
# Use the function by passing the file path (excluding the extension)

def row_packing_to_bins(rectangles, bin_width, bin_height):
    bins = []
    rectangles.sort(key=lambda x:  (x['height'], x['width']), reverse=True)  
    for item in rectangles:
        placed = False
        for bin in bins:
            if bin.add_rectangle((item['width'], item['height'])):
                placed = True
                break
        if not placed:
            # Create new bin if it doesn't fit in any existing bins
            new_bin = Bin(bin_width, bin_height)
            if new_bin.add_rectangle((item['width'], item['height'])):
                bins.append(new_bin)
            else:
                print(f"Rectangle {item} doesn't fit in a new bin with dimensions {bin_width}x{bin_height}")

    return bins


try:
    result = read_items("../InstanceSets/InstanceSet1/cl_05_100_08")
    rectangles = result['items']
    bin_width = result['bin_width']
    bin_height = result['bin_height']
    bins = row_packing_to_bins(rectangles, bin_width, bin_height)
    count = 0
    for bin in bins:
        for row in bin.rows:
            for item in row['rectangles']:
                count += 1
    print("number of packed items: ", count)
    print("number of bins: ", len(bins))

    visualize_bins(bins, 'packed_bins.png')
except RuntimeError as e:
    print(e)
