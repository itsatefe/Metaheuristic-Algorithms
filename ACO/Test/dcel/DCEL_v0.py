class Vertex:
    def __init__(self, x, y):
        self.x = x
        self.y = y

class HalfEdge:
    def __init__(self, origin, face=None):
        self.origin = origin
        self.twin = None
        self.next = None
        self.prev = None
        self.face = face

class Face:
    def __init__(self):
        self.edge = None  # Starting edge for this face

    def area(self):
        # Compute the area of the face using the edges
        e = self.edge
        vertices = []
        while True:
            vertices.append((e.origin.x, e.origin.y))
            e = e.next
            if e == self.edge:
                break
        # Compute polygon area using the shoelace formula
        return abs(sum(vertices[i][0]*vertices[(i+1)%len(vertices)][1] - vertices[(i+1)%len(vertices)][0]*vertices[i][1] for i in range(len(vertices))) / 2.0)

class Mesh:
    def __init__(self, width, height):
        self.vertices = []
        self.edges = []
        self.faces = []
        self.create_boundary(width, height)

    def create_boundary(self, width, height):
        # Create vertices
        v1 = Vertex(0, 0)
        v2 = Vertex(width, 0)
        v3 = Vertex(width, height)
        v4 = Vertex(0, height)
        self.vertices.extend([v1, v2, v3, v4])
        
        # Create edges
        e1 = HalfEdge(v1)
        e2 = HalfEdge(v2)
        e3 = HalfEdge(v3)
        e4 = HalfEdge(v4)
        self.edges.extend([e1, e2, e3, e4])
        
        # Link edges
        e1.next = e2
        e2.next = e3
        e3.next = e4
        e4.next = e1
        e1.prev = e4
        e2.prev = e1
        e3.prev = e2
        e4.prev = e3
        
        # Create face
        outer_face = Face()
        outer_face.edge = e1
        self.faces.append(outer_face)
        
        # Set face for all edges
        for e in self.edges:
            e.face = outer_face

    def insert_rectangle(self, x1, y1, x2, y2):
        # Create vertices for the rectangle
        v1 = Vertex(x1, y1)
        v2 = Vertex(x2, y1)
        v3 = Vertex(x2, y2)
        v4 = Vertex(x1, y2)
        self.vertices.extend([v1, v2, v3, v4])

        # Create edges for the rectangle
        e1 = HalfEdge(v1)
        e2 = HalfEdge(v2)
        e3 = HalfEdge(v3)
        e4 = HalfEdge(v4)
        self.edges.extend([e1, e2, e3, e4])

        # Link edges cyclically
        e1.next = e2
        e2.next = e3
        e3.next = e4
        e4.next = e1
        e1.prev = e4
        e2.prev = e1
        e3.prev = e2
        e4.prev = e3

        # Create a new face for this rectangle
        new_face = Face()
        new_face.edge = e1
        self.faces.append(new_face)

        # Set face for all edges
        for e in [e1, e2, e3, e4]:
            e.face = new_face

        # In a more complex scenario, you would need to update surrounding faces and edges,
        # handle intersections, and potentially merge or split faces. This requires advanced geometric algorithms.


    def find_unoccupied_spaces(self):
        # The unoccupied space will initially be the outer face area minus the sum of all inner face areas
        total_area = self.faces[0].area()
        occupied_area = sum(face.area() for face in self.faces[1:])
        return total_area - occupied_area


# Example Usage
mesh = Mesh(100, 100)  # Bin size 100x100
mesh.insert_rectangle(10, 10, 40, 40)  # Insert a rectangle
print(f"Unoccupied space: {mesh.find_unoccupied_spaces()} square units")
