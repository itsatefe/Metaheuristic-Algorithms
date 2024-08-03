from shapely.geometry import Polygon
from shapely.ops import unary_union
import matplotlib.pyplot as plt

# Convert rectangle coordinates to Shapely polygons
def rectangles_to_polygons(rectangles):
    polygons = [Polygon([(x1, y1), (x2, y1), (x2, y2), (x1, y2)]) for (x1, x2, y1, y2) in rectangles]
    return polygons

# Merge polygons using unary_union from Shapely
def merge_polygons(polygons):
    merged_polygon = unary_union(polygons)
    return merged_polygon

# Plot the final merged polygon
def plot_polygon(polygon, title):
    fig, ax = plt.subplots()
    x, y = polygon.exterior.xy
    ax.fill(x, y, alpha=0.5, fc='r', ec='none')
    ax.set_xlim(0, 100)
    ax.set_ylim(0, 100)
    ax.set_title(title)
    plt.gca().set_aspect('equal', adjustable='box')
    plt.show()

# Example rectangles
rectangles = [(98, 100, 0, 100), (55, 56, 7, 100), (85, 90, 13, 100), (91, 96, 13, 100), 
              (11, 48, 16, 100), (72, 82, 19, 100), (0, 5, 21, 100), (56, 72, 22, 100), 
              (48, 55, 23, 100), (96, 98, 29, 100), (5, 11, 33, 100), (90, 91, 49, 100), 
              (82, 85, 65, 100)]

polygons = rectangles_to_polygons(rectangles)
merged_polygon = merge_polygons(polygons)
plot_polygon(merged_polygon, 'Merged Polygon from Rectangles')

# Define a function to subtract one polygon from another
def subtract_polygons(main_polygon, subtracting_polygon):
    result_polygon = main_polygon.difference(subtracting_polygon)
    return result_polygon

# Example new rectangle to subtract
subtract_rectangle = (10, 20, 30, 40)  # Example coordinates for the subtracting rectangle
subtracting_polygon = Polygon([(subtract_rectangle[0], subtract_rectangle[2]), 
                               (subtract_rectangle[1], subtract_rectangle[2]), 
                               (subtract_rectangle[1], subtract_rectangle[3]), 
                               (subtract_rectangle[0], subtract_rectangle[3])])

# Subtract the new rectangle from the merged polygon
resulting_polygon = subtract_polygons(merged_polygon, subtracting_polygon)

# Plot the resulting polygon
plot_polygon(resulting_polygon, 'Polygon After Subtraction')
