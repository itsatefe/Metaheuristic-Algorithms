import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
import networkx as nx


class UnionFind:
    def __init__(self, size):
        self.parent = list(range(size))
        self.rank = [0] * size

    def find(self, p):
        if self.parent[p] != p:
            self.parent[p] = self.find(self.parent[p])
        return self.parent[p]

    def union(self, p, q):
        rootP = self.find(p)
        rootQ = self.find(q)
        if rootP != rootQ:
            if self.rank[rootP] > self.rank[rootQ]:
                self.parent[rootQ] = rootP
            elif self.rank[rootP] < self.rank[rootQ]:
                self.parent[rootP] = rootQ
            else:
                self.parent[rootQ] = rootP
                self.rank[rootP] += 1

def are_adjacent(rect1, rect2):
    x1, x2, y1, y2 = rect1
    x3, x4, y3, y4 = rect2
    # Horizontal adjacency
    horizontal = (y2 >= y3 and y1 <= y4) or (y4 >= y1 and y3 <= y2)
    # Vertical adjacency
    vertical = (x2 >= x3 and x1 <= x4) or (x4 >= x1 and x3 <= x2)
    return horizontal and vertical

def merge_rectangles(rectangles):
    uf = UnionFind(len(rectangles))
    for i in range(len(rectangles)):
        for j in range(i + 1, len(rectangles)):
            if are_adjacent(rectangles[i], rectangles[j]):
                uf.union(i, j)

    merged = {}
    for i in range(len(rectangles)):
        root = uf.find(i)
        if root not in merged:
            merged[root] = rectangles[i]
        else:
            x1, x2, y1, y2 = merged[root]
            x3, x4, y3, y4 = rectangles[i]
            new_x1 = min(x1, x3)
            new_x2 = max(x2, x4)
            new_y1 = min(y1, y3)
            new_y2 = max(y2, y4)
            merged[root] = (new_x1, new_x2, new_y1, new_y2)
    return list(merged.values())

def plot_rectangles(rectangles):
    fig, ax = plt.subplots()
    for x1, x2, y1, y2 in rectangles:
        ax.add_patch(Rectangle((x1, y1), x2 - x1, y2 - y1, edgecolor='blue', facecolor='none', linewidth=2))
    ax.set_xlim(0, 100)
    ax.set_ylim(0, 100)
    ax.set_title('Merged Rectangles')
    plt.gca().set_aspect('equal', adjustable='box')
    plt.show()







# Example rectangles
rectangles = [(98, 100, 0, 100), (55, 56, 7, 100), (85, 90, 13, 100), (91, 96, 13, 100), (11, 48, 16, 100), (72, 82, 19, 100), (0, 5, 21, 100), (56, 72, 22, 100), (48, 55, 23, 100), (96, 98, 29, 100), (5, 11, 33, 100), (90, 91, 49, 100), (82, 85, 65, 100)]
unoccupied_areas = [(0,100,0,100)]
container_width, container_height= 100,100
plot_rectangles(rectangles)
merged_rectangles = merge_rectangles(rectangles)
print(merged_rectangles)
plot_rectangles(merged_rectangles)
