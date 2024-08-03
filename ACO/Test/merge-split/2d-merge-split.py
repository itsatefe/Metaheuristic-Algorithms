import matplotlib.pyplot as plt
import matplotlib.patches as patches

class Space:
    def __init__(self, x, y, width, height):
        self.x = x
        self.y = y
        self.width = width
        self.height = height

    def is_adjacent_horizontal(self, other):
        # Check horizontal adjacency
        return (self.y == other.y and self.height == other.height and
                (abs(self.x + self.width - other.x) <= 1 or abs(other.x + other.width - self.x) <= 1))
    
    def is_adjacent_vertical(self, other):
        # Check vertical adjacency
        return (self.x == other.x and self.width == other.width and
                (abs(self.y + self.height - other.y) <= 1 or abs(other.y + other.height - self.y) <= 1))
    
    def merge(self, other):
        if self.is_adjacent_horizontal(other):
            new_x = min(self.x, other.x)
            new_width = max(self.x + self.width, other.x + other.width) - new_x
            return Space(new_x, self.y, new_width, self.height)
        elif self.is_adjacent_vertical(other):
            new_y = min(self.y, other.y)
            new_height = max(self.y + self.height, other.y + other.height) - new_y
            return Space(self.x, new_y, self.width, new_height)
        return None

class Bin:
    def __init__(self):
        self.spaces = []
    
    def add_space(self, space):
        self.spaces.append(space)
    
    def merge_spaces(self):
        merged = True
        while merged:
            merged = False
            new_spaces = []
            while self.spaces:
                space = self.spaces.pop(0)
                for i in range(len(new_spaces)):
                    merged_space = space.merge(new_spaces[i])
                    if merged_space:
                        new_spaces[i] = merged_space
                        merged = True
                        break
                else:
                    new_spaces.append(space)
            self.spaces = new_spaces

    def plot(self):
        fig, ax = plt.subplots()
        for space in self.spaces:
            rect = patches.Rectangle((space.x, space.y), space.width, space.height, linewidth=1, edgecolor='r', facecolor='none')
            ax.add_patch(rect)
        plt.xlim(0, 200)
        plt.ylim(0, 200)
        plt.gca().set_aspect('equal', adjustable='box')
        plt.show()

# # Example of usage
# bin = Bin()
# bin.add_space(Space(0, 0, 50, 50))
# bin.add_space(Space(50, 0, 25, 50))  # Horizontally adjacent
# bin.add_space(Space(0, 50, 100, 50))  # Vertically adjacent
# bin.plot()

# bin.merge_spaces()
# bin.plot()



def merge_spaces(spaces):
    """
    Merges secondary spaces into main spaces if they meet specific geometric conditions.
    
    Parameters:
        spaces (list of dict): List of spaces where each space is a dictionary
                               containing 'L', 'x', 'y', 'W', and 'id' keys.
    
    Returns:
        list of dict: The list of spaces after merging.
    """
    merged = True
    while merged:
        merged = False
        i = 0
        while i < len(spaces) - 1:
            j = i + 1
            while j < len(spaces):
                can_merge = False
                # Extract the properties of both spaces for easier access
                # space_i -> id = 2

                if spaces[i]['w'] > spaces[j]['w']:
                    space = spaces[j]
                    spaces[j] = spaces[i]
                    spaces[i] = space

                space_i = spaces[i]
                space_j = spaces[j]
                # Condition 1: Checking length and position for merging along width
                if (space_i['L'] <= space_j['L'] and
                    space_i['x'] >= space_j['x'] and
                    space_j['y'] == space_i['y'] + space_i['w']):
                    new_height = space_i['w'] + space_j['w']
                    spaces[i]['w'] = new_height
                    spaces[i]['y'] =  space_j['y']
                    can_merge = True
                    print("condition 1")

                # Condition 2: Checking length and position for merging along width
                elif (space_i['L'] <= space_j['L'] and
                    space_i['x'] >= space_j['x'] and
                    space_i['y'] == space_j['y'] + space_j['w']):
                    new_height = space_i['w'] + space_j['w']
                    spaces[i]['w'] = new_height
                    spaces[i]['y'] = space_j['y']
                    can_merge = True
                    print("condition 2")

                # Condition 3: Checking other geometric alignments, for example:
                elif (space_i['w'] <= space_j['w'] and
                      space_i['y'] >= space_j['y'] and
                      space_j['x'] == space_i['x'] + space_i['L']):
                    
                    can_merge = True
                    new_width = space_i['L'] + space_j['L']
                    spaces[i]['L'] = new_width
                    if spaces[i]['x'] > space_j['x']:
                        spaces[i]['x'] = space_j['x']  
                    if spaces[i]['w'] != space_j['w']:
                        spaces[j]['w'] = space_j['w'] - space_i['w']
                        spaces[j]['y'] = space_i['y'] + space_i['w'] 
                        print("condition 3")
                    break
                    # do something

                
                # Condition 4: Checking other geometric alignments, for example:
                elif (space_i['w'] <= space_j['w'] and
                      space_i['y'] >= space_j['y'] and
                      space_i['x'] == space_j['x'] + space_j['L']):
                    
                    new_width = space_i['L'] + space_j['L']
                    spaces[i]['L'] = new_width
                    if spaces[i]['x'] > space_j['x']:
                        spaces[i]['x'] = space_j['x']
                    if space_i['w'] != space_j['w']:
                        spaces[j]['w'] = space_j['w'] - space_i['w']
                        spaces[j]['y'] = space_i['y'] + space_i['w'] 
                        print("condition 4")

                    
                    can_merge = True
                    # do something

                
                if can_merge:
                    # spaces.pop(j)
                    merged = True
                    break
                else:
                    j += 1
            if not merged:
                i += 1
            if merged:
                break

    return spaces



import matplotlib.pyplot as plt
import matplotlib.patches as patches

def plot_spaces(spaces):
    """
    Plots the given spaces on a 2D plane to visualize their arrangement and merging results.

    Parameters:
        spaces (list of dict): List of spaces where each space is a dictionary
                               containing 'L' (length), 'x', 'y', and 'W' (width) keys.
    """
    fig, ax = plt.subplots()
    for space in spaces:
        rect = patches.Rectangle((space['x'], space['y']), space['L'], space['w'], 
                                 linewidth=1, edgecolor='r', facecolor='none')
        ax.add_patch(rect)
        # Label spaces with their IDs
        ax.text(space['x'] + space['L']/2, space['y'] + space['w']/2, f"ID {space['id']}",
                verticalalignment='center', horizontalalignment='center')

    ax.set_xlim(0, max(space['x'] + space['L'] for space in spaces) + 1)
    ax.set_ylim(0, max(space['y'] + space['w'] for space in spaces) + 1)
    ax.set_title('Visualization of Spaces')
    ax.set_xlabel('Length')
    ax.set_ylabel('Width')
    plt.gca().set_aspect('equal', adjustable='box')
    plt.show()


# Example usage
spaces = [


    {'id': 1, 'L': 5, 'x': 4, 'y': 0, 'w': 3},
    {'id': 2, 'L': 4, 'x': 0, 'y': 0, 'w': 2},


    # {'id': 3, 'L': 2, 'x': 5, 'y': 0, 'w': 5}
]

plot_spaces(spaces)
merged_spaces = merge_spaces(spaces)
plot_spaces(merged_spaces)

print("Merged Spaces:", merged_spaces)
