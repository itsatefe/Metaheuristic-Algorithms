import random
import math
from typing import List, Tuple, Dict
import RectanglePlacement as rp

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

# fitness definition
class Rectangle:
    def __init__(self, id: int, width: int, height: int):
        self.width = width
        self.height = height
        self.id = id
        self.area = self.width * self.height
        self.x = 0
        self.y = 0
        self.area = width * height

    def get_area(self) -> int:
        return self.area


    def __repr__(self): 
        return (f"Rectangle(ID={self.id}, Size=({self.width}x{self.height}), "
                f"Position=({self.x}, {self.y})")

class Container:
    def __init__(self, width: int, height: int):
        self.width = width
        self.height = height
        self.content = []
        self.unoccupied_spaces = [Space(0, width, 0, height)]
        self.available_area = width * height
        self.total_area = width * height

    def can_fit(self, rectangle: Rectangle) -> bool:
        if self.available_area >= rectangle.get_area():
            return True
        else:
            return False

    def add_rectangle(self, rectangle: Rectangle) -> bool:
        if not self.can_fit(rectangle):
            return False
        new_rect_position, self.unoccupied_spaces = rp.place_rectangle(rectangle.width, rectangle.height,
                                                                       self.unoccupied_spaces)
        if new_rect_position is not None:
            rectangle.x = new_rect_position[0]
            rectangle.y = new_rect_position[1]
            self.content.append(rectangle)
            self.available_area -= rectangle.get_area()
            return True
        # else:
        #     print("No free space")
        return False

    def get_fitness(self) -> float:
        total_area = self.width * self.height
        a = (float(total_area - self.available_area) / (total_area))
        return pow(a, 2)

    def __repr__(self):
        content_str = ", ".join(repr(rect) for rect in self.content)
        return f"Container(Content=[{content_str}])"

