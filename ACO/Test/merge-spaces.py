import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle

class Item:
    def __init__(self, x1, x2, y1, y2):
        self.x1 = min(x1, x2)  # Ensure x1 is always the smaller value
        self.x2 = max(x1, x2)  # Ensure x2 is always the larger value
        self.y1 = min(y1, y2)  # Ensure y1 is always the smaller value
        self.y2 = max(y1, y2)  # Ensure y2 is always the larger value

    def is_adjacent(self, other):
        horizontal_adjacent = (self.x2 == other.x1 or self.x1 == other.x2) and (max(self.y1, other.y1) < min(self.y2, other.y2))
        vertical_adjacent = (self.y2 == other.y1 or self.y1 == other.y2) and (max(self.x1, other.x1) < min(self.x2, other.x2))
        return horizontal_adjacent or vertical_adjacent

    
    def expand_to_include(self, other):
        if self.is_adjacent(other):
            self.x1 = min(self.x1, other.x1)
            self.x2 = max(self.x2, other.x2)
            self.y1 = min(self.y1, other.y1)
            self.y2 = max(self.y2, other.y2)



def merge_spaces(unoccupied_spaces):
    items = [Item(x1, x2, y1, y2) for x1, x2, y1, y2 in unoccupied_spaces]
    merged = merge_rectangles(items)
    return [(rect.x1, rect.x2, rect.y1, rect.y2) for rect in merged]

def find_components(items):
    adj_list = {item: [] for item in items}
    for item in items:
        for other in items:
            if item != other and item.is_adjacent(other):
                adj_list[item].append(other)

    visited = set()
    components = []
    for item in items:
        if item not in visited:
            component = []
            dfs(item, visited, component, adj_list)
            components.append(component)
    return components

def dfs(node, visited, component, adj_list):
    stack = [node]
    while stack:
        node = stack.pop()
        if node not in visited:
            visited.add(node)
            component.append(node)
            stack.extend(adj_list[node])

def merge_rectangles(items):
    changed = True
    while changed:
        changed = False
        merged_items = []
        while items:
            current = items.pop(0)
            merged = False
            for idx in range(len(merged_items)):
                if merged_items[idx].is_adjacent(current):
                    merged_items[idx].expand_to_include(current)
                    merged = True
                    changed = True
                    break
            if not merged:
                merged_items.append(current)
        items = merged_items.copy()  # Make sure to work with a copy of the list for the next iteration
    return items


def plot_rectangles(rectangles):
    fig, ax = plt.subplots()
    for rect in rectangles:
        ax.add_patch(Rectangle((rect.x1, rect.y1), rect.x2 - rect.x1, rect.y2 - rect.y1, edgecolor='blue', facecolor='none', linewidth=2))
    ax.set_xlim(0, 100)  # Adjust these limits based on your actual data
    ax.set_ylim(0, 100)
    ax.set_title('Merged Rectangles')
    plt.gca().set_aspect('equal', adjustable='box')
    plt.show()

# Example rectangles
rectangles = [(98, 100, 0, 100), (55, 56, 7, 100), (85, 90, 13, 100), (91, 96, 13, 100), (11, 48, 16, 100), (72, 82, 19, 100), (0, 5, 21, 100), (56, 72, 22, 100), (48, 55, 23, 100), (96, 98, 29, 100), (5, 11, 33, 100), (90, 91, 49, 100), (82, 85, 65, 100)]

plot_rectangles([Item(*rect) for rect in rectangles])

merged_rectangles = merge_spaces(rectangles)
plot_rectangles([Item(*rect) for rect in merged_rectangles])
