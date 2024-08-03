import matplotlib.pyplot as plt
from shapely.geometry import Polygon, box
from shapely.ops import unary_union

# Example polygon (union of two rectangles)
rect1 = box(1, 1, 3, 3)
rect2 = box(2, 2, 4, 4)
polygon = unary_union([rect1, rect2])

# Try to find a large rectangle in the polygon
minx, miny, maxx, maxy = polygon.bounds
candidate_rect = box(minx, miny, maxx, maxy)

# Intersect candidate rectangle with the polygon to ensure it fits
largest_rectangle = candidate_rect.intersection(polygon)

# Plotting
fig, ax = plt.subplots()
x, y = polygon.exterior.xy
ax.fill(x, y, alpha=0.5, color='blue', label="Polygon")

if not largest_rectangle.is_empty:
    x, y = largest_rectangle.exterior.xy
    ax.fill(x, y, alpha=0.5, color='red', label="Largest Rectangle")

ax.set_xlim(0, 5)
ax.set_ylim(0, 5)
ax.set_aspect('equal')
ax.legend()
plt.show()
