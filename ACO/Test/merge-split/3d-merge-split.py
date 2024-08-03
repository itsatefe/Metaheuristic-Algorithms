class Space:
    def __init__(self, x, y, z, length, width, height):
        self.x = x  # x-coordinate of the space
        self.y = y  # y-coordinate of the space
        self.z = z  # z-coordinate of the space (height level)
        self.length = length
        self.width = width
        self.height = height
        self.next = None  # Points to the next space in the same layer
        self.up = None  # Points to the space directly above this one in the next layer
        self.down = None  # Points to the space directly below this one in the previous layer
        self.item_packed = None  # None means no item packed, otherwise holds dimensions of the packed item

class Layer:
    def __init__(self):
        self.head = None  # Starting point of the linked list in this layer

    def add_space(self, space):
        if not self.head:
            self.head = space
        else:
            current = self.head
            while current.next:
                current = current.next
            current.next = space

    def find_space(self, required_length, required_width, required_height):
        """ Find the first space that fits the given dimensions """
        current = self.head
        while current:
            if (current.length >= required_length and
                current.width >= required_width and
                current.height >= required_height):
                return current
            current = current.next
        return None

class Bin:
    def __init__(self):
        self.layers = []  # List of layers

    def add_layer(self, layer):
        self.layers.append(layer)
        if len(self.layers) > 1:
            previous_layer = self.layers[-2]
            current_layer = self.layers[-1]
            prev_node = previous_layer.head
            curr_node = current_layer.head
            while prev_node and curr_node:
                prev_node.up = curr_node
                curr_node.down = prev_node
                prev_node = prev_node.next
                curr_node = curr_node.next

    def pack_item(self, length, width, height):
        """ Attempt to pack an item into the bin """
        for layer in self.layers:
            space = layer.find_space(length, width, height)
            if space:
                print(f"Packing item in space at ({space.x}, {space.y}, {space.z})")
                # Set the dimensions of the packed item
                space.item_packed = (length, width, height)
                return True
        print("No suitable space found")
        return False

# Visualization function remains the same


import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

def visualize_bin(bin):
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    colors = ['blue', 'red', 'green', 'yellow', 'purple']  # Different colors for different layers
    
    for i, layer in enumerate(bin.layers):
        current = layer.head
        color = colors[i % len(colors)]
        while current:
            # Draw the space
            x, y, z = current.x, current.y, current.z
            length, width, height = current.length, current.width, current.height
            ax.bar3d(x, y, z, width, length, height, alpha=0.1, color='blue')
            
            # Optionally, visualize an item being packed
            if hasattr(current, 'item_packed') and current.item_packed:
                item_length, item_width, item_height = current.item_packed
                ax.bar3d(x, y, z, item_width, item_length, item_height, alpha=0.8, color='red')

            current = current.next

    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    plt.show()


# Create a new bin
bin = Bin()

# Add layers and spaces to the bin
layer1 = Layer()
layer1.add_space(Space(0, 0, 0, 100, 100, 10))  # Base layer
bin.add_layer(layer1)

layer2 = Layer()
layer2.add_space(Space(0, 0, 10, 100, 100, 10))  # Second layer directly above the first
bin.add_layer(layer2)

# Attempt to pack an item
bin.pack_item(50, 50, 5)
visualize_bin(bin)

