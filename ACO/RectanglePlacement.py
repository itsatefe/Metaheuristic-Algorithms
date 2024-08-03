import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
from RLSweepLine import *
from TBSweepLine import *
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
        
def merge_spaces(unoccupied_spaces):
    horizontally_merged_spaces = merge_horizontally(unoccupied_spaces)
    return merge_vertically(horizontally_merged_spaces)

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

def _place_rectangle_bin(w, h, unoccupied_spaces):
    # unoccupied_spaces.sort(key=lambda x: x.width * x.height)
    # if unoccupied_spaces[-1].width * unoccupied_spaces[-1].height < w*h:
    #     return None, unoccupied_spaces
        
    for i,  space in enumerate(unoccupied_spaces):
       
        x1, x2, y1, y2 = space.to_tuple()
        # Check if the rectangle can fit in the current unoccupied space
        if w <= (x2 - x1) and h <= (y2 - y1):
            # Place the rectangle in this space (left-bottom alignment)
            new_rect_position = (x1, y1, x1 + w, y1 + h)

            # Update unoccupied spaces, removing the old space and adding new spaces as necessary
            new_spaces = unoccupied_spaces[:i] + unoccupied_spaces[i+1:]  # Remove the current space
            
            # Check for and add new space above the placed rectangle
            if w < h:
                if y1 + h < y2:
                    new_spaces.append(Space(x1, x1 + w, y1 + h, y2)) 
                # Check for and add new space to the right of the placed rectangle
                if x1 + w < x2:
                    new_spaces.append(Space(x1 + w, x2, y1, y2))
            else:
                if y1 + h < y2:
                    new_spaces.append(Space(x1, x2, y1 + h, y2)) 
                # Check for and add new space to the right of the placed rectangle
                if x1 + w < x2:
                    new_spaces.append(Space(x1 + w, x2, y1, y1+h))
            return new_rect_position, new_spaces
    # print("no suitable space found")
    return None, unoccupied_spaces
    
def place_rectangle(w,h,unoccupied_spaces):
    rect_pos, unoccupied_spaces = _place_rectangle_bin(w,h,unoccupied_spaces)
    if rect_pos is None:
        if w<=h:
            sweep_line = RLSweepLine(unoccupied_spaces)
            cell_unoccupied_spaces = sweep_line.run()
            unoccupied_spaces = merge_vertically(cell_unoccupied_spaces)
            # plot_rectangles([], unoccupied_spaces, 100, 100)
            rect_pos, unoccupied_spaces = _place_rectangle_bin(w,h,unoccupied_spaces)

            if(w==h and rect_pos is None):
                sweep_line = TBSweepLine(unoccupied_spaces)
                cell_unoccupied_spaces = sweep_line.run()
                unoccupied_spaces = merge_horizontally(cell_unoccupied_spaces)
                rect_pos, unoccupied_spaces = _place_rectangle_bin(w,h,unoccupied_spaces)

        else:
            sweep_line = TBSweepLine(unoccupied_spaces)
            cell_unoccupied_spaces = sweep_line.run()
            unoccupied_spaces = merge_horizontally(cell_unoccupied_spaces)
            rect_pos, unoccupied_spaces = _place_rectangle_bin(w,h,unoccupied_spaces)

            # plot_rectangles([], unoccupied_spaces, 100, 100)
    
    return rect_pos, unoccupied_spaces 
  

def plot_rectangles(rectangles, unoccupied_areas, container_width, container_height):
    """Plot the rectangles and the unoccupied areas in the container."""
    fig, ax = plt.subplots()
    for x1, y1, x2, y2 in rectangles:
        ax.add_patch(Rectangle((x1, y1), x2 - x1, y2 - y1, edgecolor='blue', facecolor='lightblue', fill=True, label='Occupied'))
    
    # Highlight unoccupied areas
    for space in unoccupied_areas:
        ux1, ux2, uy1, uy2 = space.to_tuple()
        ax.add_patch(Rectangle((ux1, uy1), ux2 - ux1, uy2 - uy1, edgecolor='red', facecolor='none', hatch='/', label='Unoccupied'))
    
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


def calculate_total_unoccupied_area(unoccupied_spaces):
    """Calculates the total area of unoccupied spaces in a 2D container."""
    total_area = 0
    for sapce in unoccupied_spaces:
        total_area += sapce.width * sapce.height
    return total_area