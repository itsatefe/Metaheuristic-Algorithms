import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
from sortedcontainers import SortedDict

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

def merge_spaces(unoccupied_spaces):
    # Sorting by x1 and then y1 to facilitate merging
    unoccupied_spaces.sort()
    merged_spaces = []

    # Merging horizontally aligned spaces
    for space in unoccupied_spaces:
        if not merged_spaces:
            merged_spaces.append(space)
        else:
            last = merged_spaces[-1]
            # Check if the current space can be merged with the last one
            if last[1] == space[0] and last[2] == space[2] and last[3] == space[3]:
                merged_spaces[-1] = (last[0], space[1], last[2], last[3])
            else:
                merged_spaces.append(space)

    return merged_spaces


def detect_unoccupied_areas(rectangles, container_width, container_height):
    """Detect unoccupied subspaces in a 2D container."""
    events = []
    active_intervals = SortedDict()

    # Create events for each rectangle
    for (x1, y1, x2, y2) in rectangles:
        events.append((x1, 'enter', y1, y2))
        events.append((x2, 'exit', y1, y2))
    
    # Sort events
    events.sort()

    # Sweep line processing
    last_x = 0
    unoccupied_spaces = []
    for x, event_type, y1, y2 in events:
        if x != last_x:
            unoccupied_y = calculate_unoccupied_y(active_intervals, container_height)
            for uy1, uy2 in unoccupied_y:
                unoccupied_spaces.append((last_x, x, uy1, uy2))
            last_x = x
        
        if event_type == 'enter':
            add_interval(active_intervals, y1, y2)
        elif event_type == 'exit':
            remove_interval(active_intervals, y1, y2)

    # Final sweep to the end of the container width
    unoccupied_y = calculate_unoccupied_y(active_intervals, container_height)
    for uy1, uy2 in unoccupied_y:
        unoccupied_spaces.append((last_x, container_width, uy1, uy2))
    merged_spaces = merge_spaces(unoccupied_spaces)
    return merged_spaces

def place_rectangle(w, h, unoccupied_spaces):
    for i, (x1, x2, y1, y2) in enumerate(unoccupied_spaces):
        # Check if the rectangle can fit in the current unoccupied space
        if w <= (x2 - x1) and h <= (y2 - y1):
            # Place the rectangle in this space (left-bottom alignment)
            new_rect_position = (x1, y1, x1 + w, y1 + h)

            # Update unoccupied spaces, removing the old space and adding new spaces as necessary
            new_spaces = unoccupied_spaces[:i] + unoccupied_spaces[i+1:]  # Remove the current space
            
            # Check for and add new space above the placed rectangle
            if y1 + h < y2:
                new_spaces.append((x1, x2, y1 + h, y2))
            
            # Check for and add new space to the right of the placed rectangle
            if x1 + w < x2:
                new_spaces.append((x1 + w, x2, y1, y2))

            # Re-merge the spaces to maintain proper intervals
            merged_spaces = merge_spaces(new_spaces)
            return new_rect_position, merged_spaces

    # No suitable space found; return None and the original merged spaces
    return None, unoccupied_spaces

# Redefining the plot function for clear visibility of the issue and fix
def plot_rectangles(rectangles, unoccupied_areas, container_width, container_height):
    """Plot the rectangles and the unoccupied areas in the container."""
    fig, ax = plt.subplots()
    # Draw all rectangles
    for x1, y1, x2, y2 in rectangles:
        ax.add_patch(Rectangle((x1, y1), x2 - x1, y2 - y1, edgecolor='blue', facecolor='lightblue', fill=True, label='Occupied'))
    
    # Highlight unoccupied areas
    for ux1, ux2, uy1, uy2 in unoccupied_areas:
        ax.add_patch(Rectangle((ux1, uy1), ux2 - ux1, uy2 - uy1, edgecolor='red', facecolor='none', hatch='/', label='Unoccupied'))
    
    # Set the limits of the plot to the size of the container
    ax.set_xlim(0, container_width)
    ax.set_ylim(0, container_height)
    ax.set_title('2D Container with Occupied and Unoccupied Spaces')
    ax.set_xlabel('Width')
    ax.set_ylabel('Height')
    
    # Create legend with unique handles
    handles, labels = ax.get_legend_handles_labels()
    unique = [(h, l) for i, (h, l) in enumerate(zip(handles, labels)) if l not in labels[:i]]
    ax.legend(*zip(*unique))
    
    plt.gca().set_aspect('equal', adjustable='box')
    plt.show()

# This should ensure that after placing a rectangle, the unoccupied spaces reflect the current state correctly.



def calculate_total_unoccupied_area(unoccupied_spaces):
    """Calculates the total area of unoccupied spaces in a 2D container."""
    total_area = 0
    for x1, x2, y1, y2 in unoccupied_spaces:
        width = x2 - x1
        height = y2 - y1
        total_area += width * height
    return total_area

rectangles = [(6,0,10,5),(0,6,9,10)]
container_width = 10
container_height = 10
unoccupied_areas = detect_unoccupied_areas(rectangles, container_width, container_height)
print("first unoccupied_areas: ", unoccupied_areas)
plot_rectangles(rectangles, unoccupied_areas, container_width, container_height)
total_unoccupied_area = calculate_total_unoccupied_area(unoccupied_areas)
print("Total Unoccupied Area:", total_unoccupied_area)

rect_w, rect_h = 4, 5  # Size of the new rectangle to place
placed_rect, updated_unoccupied = place_rectangle(rect_w, rect_h, unoccupied_areas)
if placed_rect:
    print("Placed new rectangle at:", placed_rect)
else:
    print("No suitable space found to place the rectangle.")

rectangles.append(placed_rect)
plot_rectangles(rectangles, updated_unoccupied, container_width, container_height)
print("updated unoccupied areas: ", updated_unoccupied)
