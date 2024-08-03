from sortedcontainers import SortedList
import matplotlib.pyplot as plt
import matplotlib.patches as patches

class rectangle:
    def __init__(self, x: int, y: int, width: int, height: int):
        self.x1 = x
        self.y1 = y
        self.x2 = x + width
        self.y2 = y + height
        self.width = width
        self.height = height

    def __repr__(self):
        return f"rectangle({self.x1},{self.y1},{self.width},{self.height})"

def check_overlap(rect1, rect2):
    # Check if two rectangles overlap (touching is not considered overlap)
    if (rect1.x1 < rect2.x2 and rect1.x2 > rect2.x1 and
        rect1.y1 < rect2.y2 and rect1.y2 > rect2.y1):
        return True
    return False

def detect_overlap(rectangles):
    events = []
    active_rectangles = SortedList(key=lambda x: x.y1)

    # Generate events for the sweepline
    for rect in rectangles:
        events.append(('start', rect.x1, rect))
        events.append(('end', rect.x2, rect))

    # Sort events, primarily by x coordinate, secondarily by type ('start' before 'end')
    events.sort(key=lambda x: (x[1], x[0] == 'end'))

    for event in events:
        _, x, rect = event
        if event[0] == 'start':
            # Check for overlap with all currently active rectangles
            for active in active_rectangles:
                if check_overlap(rect, active):
                    return True
            active_rectangles.add(rect)
        else:
            active_rectangles.remove(rect)

    return False



def plot_rectangles(rectangles):
    fig, ax = plt.subplots()
    for rect in rectangles:
        # Create a rectangle patch and add it to the plot
        patch = patches.Rectangle((rect.x1, rect.y1), rect.width, rect.height, linewidth=1, edgecolor='r', facecolor='none')
        ax.add_patch(patch)
        # Annotate the rectangle with its ID
        # ax.text(rect.x1 + rect.width/2, rect.y1 + rect.height/2, str(rect.id), color='blue', weight='bold', ha='center', va='center')
    
    # Set plot limits and show the plot
    ax.set_xlim(0, max(rect.x2 for rect in rectangles) + 1)
    ax.set_ylim(0, max(rect.y2 for rect in rectangles) + 1)
    ax.set_aspect('equal')
    plt.title('Rectangle Plot')
    plt.show()

# Example usage
rectangles = [rectangle(0,0,4,7), rectangle(0,0,6,9)]
if detect_overlap(rectangles):
    print("Overlap detected!")
else:
    print("No overlap detected.")
plot_rectangles(rectangles)