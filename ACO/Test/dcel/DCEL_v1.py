import math as m

def findHAngle(dx, dy):
    """Determines the angle with respect to the x axis of a segment
    of coordinates dx and dy, accounting for floating-point precision issues.
    """
    l = m.sqrt(dx * dx + dy * dy)
    if l == 0:
        return 0  # Prevent division by zero if l is zero
    cos_angle = dx / l
    # Correct potential floating-point precision issues
    cos_angle = max(-1.0, min(1.0, cos_angle))
    angle = m.acos(cos_angle)
    if dy < 0:
        angle = 2 * m.pi - angle
    return angle



class Vertex:
    def __init__(self, x, y):
        self.x = x
        self.y = y
        self.hedges = []  # list of halfedges whose tail is this vertex

    def __eq__(self, other):
        if isinstance(other, Vertex):
            return self.x == other.x and self.y == other.y
        return NotImplemented

    def sortHedges(self):
        self.hedges.sort(key=lambda a: a.angle, reverse=True)

    def __repr__(self):
        return "({0},{1})".format(self.x, self.y)


class Hedge:
    # v1 -> v2
    def __init__(self, v1, v2):
        self.prev = None
        self.twin = None
        self.next = None
        self.tail = v1
        self.face = None
        self.angle = findHAngle(v2.x-v1.x, v2.y-v1.y)

    def __eq__(self, other):
        return isinstance(other, Hedge) and self.tail == other.tail and self.next.tail == other.next.tail

    def __hash__(self):
        return hash((self.tail.x, self.tail.y, self.next.tail.x, self.next.tail.y))

    def __repr__(self):
        if self.next is not None:
            return "({0},{1})->({2},{3})".format(self.tail.x, self.tail.y,
                                                 self.next.tail.x,
                                                 self.next.tail.y)
        else:
            return "({0},{1})->()".format(self.tail.x, self.tail.y)


class Face:
    def __init__(self):
        self.halfEdge = None  # A representative half-edge on the face's boundary
        self.name = None

    def recompute_boundary(self):
        if not self.halfEdge:
            return  # No half-edge to start from

        # Start from the representative half-edge
        start_edge = self.halfEdge
        current_edge = start_edge
        boundary_edges = []

        # Traverse the edges using the 'next' pointer until we loop back to the start
        while True:
            boundary_edges.append(current_edge)
            current_edge = current_edge.next
            if current_edge == start_edge:
                break

        # Now 'boundary_edges' contains all the edges in the boundary of the face
        # We need to make sure all these edges have their 'face' attribute set to this face
        for edge in boundary_edges:
            edge.face = self

        # Optionally, you might want to update 'self.halfEdge' to be one of the boundary edges if needed
        self.halfEdge = boundary_edges[0]

    def __repr__(self):
        return f"Face({self.name})"



class DCEL:
    def __init__(self):
        self.vertices = {}  # Changed from list to dictionary
        self.hedges = []
        self.faces = []


    def validate_dcel(self):
      # Check every edge if it correctly points to valid twin, next, and prev edges
      for edge in self.hedges:
          if edge.twin is None or edge.next is None or edge.prev is None:
              raise ValueError("DCEL is corrupt: Missing necessary links in half-edges.")
          if edge.next.prev != edge or edge.prev.next != edge:
              raise ValueError("DCEL is corrupt: Inconsistent next/prev linkage.")
    def remove_edge(self, edge):
        # Disconnect edge from its vertices and adjust the linked list
        if edge.prev:
            edge.prev.next = edge.next
        if edge.next:
            edge.next.prev = edge.prev

        # Remove the edge from the vertex hedge list
        if edge in edge.tail.hedges:
            edge.tail.hedges.remove(edge)
        if edge.twin in edge.twin.tail.hedges:
            edge.twin.tail.hedges.remove(edge.twin)

        # Remove from DCEL hedge list
        if edge in self.hedges:
            self.hedges.remove(edge)
        if edge.twin in self.hedges:
            self.hedges.remove(edge.twin)

        # Update face references
        if edge.face:
            edge.face.halfEdge = None
        if edge.twin.face:
            edge.twin.face.halfEdge = None

        # Ensure that removed edge's references are cleared
        edge.next = edge.prev = edge.twin = edge.face = None
        

    def update_next_prev_links(self):
      for vertex in self.vertices.values():
          vertex.sortHedges()  # Sort half-edges in clockwise order
          num_edges = len(vertex.hedges)
          for i in range(num_edges):
              current_edge = vertex.hedges[i]
              next_edge = vertex.hedges[(i + 1) % num_edges]
              current_edge.twin.next = next_edge
              next_edge.prev = current_edge.twin


    def create_twin_edges(self, v1, v2):
      h1 = Hedge(v1, v2)
      h2 = Hedge(v2, v1)
      h1.twin = h2
      h2.twin = h1
      v1.hedges.append(h1)
      v2.hedges.append(h2)
      self.hedges.extend([h1, h2])
      return h1, h2

    def findVertex(self, x, y):
        # Check if vertex exists in the dictionary, return it if it does
        return self.vertices.get((x, y), None)

    def build_dcel(self, points, segments):
        # For each point create a vertex if it doesn't exist and add it to vertices
        for point in points:
            if point not in self.vertices:
                self.vertices[point] = Vertex(point[0], point[1])

        # For each segment, create two half-edges and assign their
        # tail vertices and twins
        for segment in segments:
            startVertex = segment[0]
            endVertex = segment[1]

            v1 = self.vertices[startVertex]
            v2 = self.vertices[endVertex]

            h1 = Hedge(v1, v2)
            h2 = Hedge(v2, v1)

            h1.twin = h2
            h2.twin = h1

            v1.hedges.append(h1)
            v2.hedges.append(h2)

            self.hedges.append(h1)
            self.hedges.append(h2)

        # Sort and link all half-edges
        for vertex in self.vertices.values():
            vertex.sortHedges()
            noOfHalfEdges = len(vertex.hedges)
            if noOfHalfEdges < 2:
                raise Exception("Invalid DCEL. There should be at least two half edges for a vertex")

            # Linking half-edges
            for i in range(noOfHalfEdges - 1):
                e1 = vertex.hedges[i]
                e2 = vertex.hedges[i + 1]

                e1.twin.next = e2
                e2.prev = e1.twin

            # Link the last to the first half-edge
            e1 = vertex.hedges[-1]
            e2 = vertex.hedges[0]

            e1.twin.next = e2
            e2.prev = e1.twin

        # Allocate and assign faces to cycles
        self.assign_faces()

    def assign_faces(self):
        faceCount = 0
        for halfEdge in self.hedges:
            if halfEdge.face is None:
                faceCount += 1
                f = Face()
                f.name = "f" + str(faceCount)
                f.halfEdge = halfEdge
                halfEdge.face = f

                h = halfEdge
                while h.next != halfEdge:
                    h = h.next
                    h.face = f
                h.face = f
                self.faces.append(f)

import matplotlib.pyplot as plt
def merge_adjacent_faces(dcel):
    # This is a placeholder for how you might start this process
    edge_face_map = {}
    for edge in dcel.hedges:
        sorted_edge = tuple(sorted([(edge.tail.x, edge.tail.y), (edge.twin.tail.x, edge.twin.tail.y)]))
        if sorted_edge in edge_face_map:
            edge_face_map[sorted_edge].append(edge.face)
        else:
            edge_face_map[sorted_edge] = [edge.face]

    # Identify faces to merge
    faces_to_merge = []
    for edges, faces in edge_face_map.items():
        if len(faces) > 1:
            faces_to_merge.append(faces)

    # Merge faces
    for face_group in faces_to_merge:
        merge_faces(dcel, face_group)

def merge_faces(dcel, faces):
    if len(faces) < 2:
        return  # No merging needed if less than two faces

    primary_face = faces[0]
    for face in faces[1:]:
        edge = face.halfEdge
        start_edge = edge
        do_continue = True

        while do_continue:
            if edge.twin.face == primary_face:
                next_edge = edge.next
                dcel.remove_edge(edge)  # Removing shared edge
                edge = next_edge
            else:
                edge = edge.next

            if edge == start_edge or edge.next == edge:
                do_continue = False

        # Remove the merged face from DCEL
        if face in dcel.faces:
            dcel.faces.remove(face)

    # Recompute the boundary of the primary face
    primary_face.recompute_boundary()

def plot_dcel(dcel):
    fig, ax = plt.subplots()
    # Define min and max for the plot explicitly
    x_min, x_max, y_min, y_max = 0, 10, 0, 10

    # Iterate through all edges in the DCEL
    for edge in dcel.hedges:
        if edge.next:  # Ensure that the next edge is not None
            start = (edge.tail.x, edge.tail.y)
            end = (edge.next.tail.x, edge.next.tail.y)
            ax.plot([start[0], end[0]], [start[1], end[1]], 'k-')  # Plot edges in black
            # Update the plot limits based on the points
            x_min = min(x_min, start[0], end[0])
            x_max = max(x_max, start[0], end[0])
            y_min = min(y_min, start[1], end[1])
            y_max = max(y_max, start[1], end[1])

    # Plot vertices as red circles
    for v in dcel.vertices.values():
        ax.plot(v.x, v.y, 'ro')

    # Set the plot limits
    ax.set_xlim(x_min - 1, x_max + 1)  # Adding a margin of 1 unit
    ax.set_ylim(y_min - 1, y_max + 1)

    # Use 'equal' aspect ratio to ensure one unit on x-axis is equal to one on y-axis
    plt.axis('equal')
    plt.show()

def generate_touching_rectangles(rectangles):
    points = set()
    raw_segments = []

    for (x1, y1, x2, y2) in rectangles:
        # Points for the current rectangle
        current_points = [
            (x1, y1),  # Bottom-left
            (x2, y1),  # Bottom-right
            (x1, y2),  # Top-left
            (x2, y2)   # Top-right
        ]
        points.update(current_points)

        current_segments = [
            ((x1, y1), (x2, y1)),  # Bottom side
            ((x2, y1), (x2, y2)),  # Right side
            ((x2, y2), (x1, y2)),  # Top side
            ((x1, y2), (x1, y1)),  # Left side
        ]
        raw_segments.extend(current_segments)

    segments = combine_segments(raw_segments)
    return list(points), segments

def combine_segments(segments):
    unique_segments = set()
    for seg in segments:
        sorted_seg = tuple(sorted(seg))
        unique_segments.add(sorted_seg)
    return list(unique_segments)

def main():
    rectangles = [
        (0, 0, 3, 5),  # Rectangle 1
        (3, 0, 6, 5),  # Rectangle 2, touches Rectangle 1 on the right
        (6, 2, 9, 7)   # Rectangle 3, not touching the first two
    ]

    points, segments = generate_touching_rectangles(rectangles)
    myDCEL = DCEL()
    myDCEL.build_dcel(points, segments)
    merge_adjacent_faces(myDCEL)  # Merge the adjacent rectangles
    plot_dcel(myDCEL)


main()
