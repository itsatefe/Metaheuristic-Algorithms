import matplotlib.pyplot as plt

import matplotlib.patches as patches


class Rect:
    def __init__(self, x1, x2, y1, y2):
        self.x1 = x1
        self.x2 = x2
        self.y1 = y1
        self.y2 = y2

    def cells(self):
        return [(x, y) for x in range(self.x1, self.x2 + 1) for y in range(self.y1, self.y2 + 1)]
    
    def __repr__(self) -> str:
        return f"({self.x1},{self.x2},{self.y1},{self.y2})"

# Define your rectangles
rectangles = [
    Rect(96, 98, 29, 100), Rect(5, 11, 33, 100), Rect(90, 91, 49, 100),
    Rect(82, 85, 65, 100), Rect(11, 48, 16, 100), Rect(72, 82, 19, 100),
    Rect(0, 5, 21, 100), Rect(56, 72, 22, 100)
]

# Create a grid to place your rectangles
max_x = max(rect.x2 for rect in rectangles)
max_y = max(rect.y2 for rect in rectangles)
grid = [[0] * (max_x + 1) for _ in range(max_y + 1)]

# Fill the grid
for rect in rectangles:
    for x, y in rect.cells():
        grid[y][x] = 1  # Assuming all rectangles are the same color
        
def flood_fill(grid, x, y, visited):
    stack = [(x, y)]
    min_x, max_x, min_y, max_y = x, x, y, y
    while stack:
        cx, cy = stack.pop()
        if (cx, cy) in visited:
            continue
        visited.add((cx, cy))
        min_x = min(min_x, cx)
        max_x = max(max_x, cx)
        min_y = min(min_y, cy)
        max_y = max(max_y, cy)
        for nx, ny in [(cx - 1, cy), (cx + 1, cy), (cx, cy - 1), (cx, cy + 1)]:
            if 0 <= nx < len(grid[0]) and 0 <= ny < len(grid) and grid[ny][nx] == 1 and (nx, ny) not in visited:
                stack.append((nx, ny))
    return min_x, max_x, min_y, max_y

# Find connected regions
visited = set()
new_rectangles = []
for y in range(max_y + 1):
    for x in range(max_x + 1):
        if grid[y][x] == 1 and (x, y) not in visited:
            bounds = flood_fill(grid, x, y, visited)
            new_rectangles.append(Rect(bounds[0],bounds[1],bounds[2],bounds[3]))






import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.patches import Rectangle

def plot_rectangles(rectangles, title):
    fig, ax = plt.subplots()
    for rect in rectangles:
        ax.add_patch(Rectangle((rect.x1, rect.y1), rect.x2 - rect.x1, rect.y2 - rect.y1, edgecolor='blue', facecolor='none', linewidth=0.4))
    ax.set_xlim(0, 100)  # Adjust these limits based on your actual data
    ax.set_ylim(0, 100)
    ax.set_title(title)
    plt.gca().set_aspect('equal', adjustable='box')
    plt.show()

plot_rectangles(rectangles,"before")

print(new_rectangles)
plot_rectangles(new_rectangles,"after")

