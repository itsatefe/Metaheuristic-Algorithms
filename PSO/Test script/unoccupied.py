import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
from sortedcontainers import SortedDict # is not used, MR! :) 

# from numba import jit
class Space:
    def __init__(self, x1, x2, y1, y2):
        self.x1 = x1
        self.x2 = x2
        self.y1 = y1
        self.y2 = y2
        self.width = x2 - x1
        self.height = y2 - y1

    def __repr__(self):
        return f"Space({self.x1}, {self.x2}, {self.y1}, {self.y2})"

    def to_tuple(self):
        return (self.x1, self.x2, self.y1, self.y2)
        

def merge_horizontally(unoccupied_spaces):
    # Sorting by y1 and then x1 to facilitate horizontal merging
    unoccupied_spaces.sort(key=lambda x: (x.y1, x.x1))
    horizontally_merged_spaces = []

    # Merging horizontally aligned spaces
    for space in unoccupied_spaces:
        if not horizontally_merged_spaces:
            horizontally_merged_spaces.append(space)
        else:
            last = horizontally_merged_spaces[-1]
            # Check if the current space is directly to the right of the last space
            if last.x2 == space.x1 and last.y1 == space.y1 and last.y2 == space.y2:
                # Extend the last space to include the current space
                horizontally_merged_spaces[-1] = Space(last.x1, space.x2, last.y1, last.y2)
            else:
                horizontally_merged_spaces.append(space)
    return horizontally_merged_spaces

def merge_vertically(unoccupied_spaces):
    vertically_merged_spaces = []
    # Sorting by x1 and then x2 to handle spaces that are exactly above/below each other
    unoccupied_spaces.sort(key=lambda x: (x.x1, x.x2,x.y1))
    
    for space in unoccupied_spaces:
        if not vertically_merged_spaces:
            vertically_merged_spaces.append(space)
        else:
            last = vertically_merged_spaces[-1]
            # Check if the current space can be merged with the last one vertically
            if last.x1 == space.x1 and last.x2 == space.x2 and last.y2 == space.y1:
                # Extend the last space's vertical boundary to include the current space
                vertically_merged_spaces[-1] = Space(last.x1, last.x2, last.y1, space.y2)
            else:
                vertically_merged_spaces.append(space)
    return vertically_merged_spaces


def merge_spaces(unoccupied_spaces):
    horizontally_merged_spaces = merge_horizontally(unoccupied_spaces)
    return merge_vertically(horizontally_merged_spaces)

       
def add_interval(active_intervals, y1, y2):
    """Add a y-interval to the active set."""
    if y1 in active_intervals:
        active_intervals[y1] += 1
    else:
        active_intervals[y1] = 1
    
    if y2 in active_intervals:
        active_intervals[y2] -= 1
    else:
        active_intervals[y2] = -1

def remove_interval(active_intervals, y1, y2):
    """Remove a y-interval from the active set."""
    if y1 in active_intervals:
        if active_intervals[y1] == 1:
            del active_intervals[y1]
        else:
            active_intervals[y1] -= 1
    else:
        active_intervals[y1] = -1
        
    if y2 in active_intervals:
        if active_intervals[y2] == -1:
            del active_intervals[y2]
        else:
            active_intervals[y2] += 1
    else:
        active_intervals[y2] = 1

def calculate_unoccupied_y(active_intervals, container_height):
    """Calculate unoccupied y-intervals."""
    current_count = 0
    last_y = 0
    unoccupied = []
    for y, count in sorted(active_intervals.items()):
        if current_count == 0 and y > last_y:
            unoccupied.append((last_y, y))
        current_count += count
        last_y = y
    if last_y < container_height:
        unoccupied.append((last_y, container_height))
    return unoccupied

def detect_unoccupied_areas(rectangles, container_width, container_height):
    """Detect unoccupied subspaces in a 2D container."""
    events = []
    active_intervals = SortedDict()

    # Create events for each rectangle
    for rect in rectangles:
        events.append((rect.x, 'enter', rect.y, rect.y + rect.height))
        events.append((rect.x + rect.width, 'exit', rect.y, rect.y + rect.height))
    
    # Sort events
    events.sort()

    # Sweep line processing
    last_x = 0
    unoccupied_spaces = []
    for x, event_type, y1, y2 in events:
        if x != last_x:
            unoccupied_y = calculate_unoccupied_y(active_intervals, container_height)
            for uy1, uy2 in unoccupied_y:
                unoccupied_spaces.append(Space(last_x, x, uy1, uy2))
            last_x = x
        
        if event_type == 'enter':
            add_interval(active_intervals, y1, y2)
        elif event_type == 'exit':
            remove_interval(active_intervals, y1, y2)

    # Final sweep to the end of the container width
    unoccupied_y = calculate_unoccupied_y(active_intervals, container_height)
    for uy1, uy2 in unoccupied_y:
        unoccupied_spaces.append(Space(last_x, container_width, uy1, uy2))
    merged_spaces = merge_spaces(unoccupied_spaces)
    return merged_spaces

class rectangle:
    def __init__(self, x, y, width, height):
        self.x = x
        self.y = y
        self.width = width
        self.height = height

# Define container dimensions
container_width = 10
container_height = 10

# Define rectangles within the container
rectangles = [rectangle(0,0,6,4), rectangle(5,0,4,10), rectangle(0,4,5,2), rectangle(3,5,4,1)]
# Call the function to detect unoccupied areas
unoccupied_spaces = detect_unoccupied_areas(rectangles, container_width, container_height)

# Display the unoccupied spaces
for space in unoccupied_spaces:
    print(space)


# Set up the plot
fig, ax = plt.subplots()
ax.set_xlim(0, container_width)
ax.set_ylim(0, container_height)
ax.set_aspect('equal')

# Plot each rectangle
for rect in rectangles:
    ax.add_patch(Rectangle((rect.x, rect.y), rect.width, rect.height, edgecolor='blue', facecolor='blue', alpha=0.3))

# Highlight unoccupied spaces
for space in unoccupied_spaces:
    ax.add_patch(Rectangle((space.x1, space.y1), space.width, space.height, edgecolor='red', facecolor='none', linestyle='--'))

plt.show()
