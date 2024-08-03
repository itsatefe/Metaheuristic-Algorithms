import random
import math
from typing import List, Tuple, Dict
import RectanglePlacement as rp
from collections import namedtuple
from sortedcontainers import SortedList

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

    def get_width(self):
        return self.width
    
    def get_height(self):
        return self.height

    # def __repr__(self): 
    #     return (f"Rectangle(ID={self.id}, Size=({self.width}x{self.height}), "
    #             f"Position=({self.x}, {self.y})")

    def __repr__(self): 
        return (f"rectangle({self.x},{self.y},{self.width},{self.height})")


class Container:
    def __init__(self, width: int, height: int, content=None):
        self.width = width
        self.height = height
        self.total_area = width * height

        if content  is None:
            self.content = {}
            self.unoccupied_spaces = [Space(0, width, 0, height)]
            self.available_area = width * height
        else:
            self.content = content
            self.unoccupied_spaces = rp.detect_unoccupied_areas(self.content.values(), self.width, self.height)
            self.available_area = self.calculate_available_area()
            
        # self.feasible = self.check_feasibility()
        self.feasible = True

    def calculate_available_area(self):
        return self.total_area - sum([rect.area for rect in self.content.values()])


    def can_fit(self, rectangle: Rectangle) -> bool:
        if self.available_area >= rectangle.get_area():
            return True
        else:
            return False

    def remove(self,item):
        # self.content = {key:obj for key,obj in self.content.items() if obj.id != item.id} # change
        item_to_remove = self.content.pop(item.id)
        self.available_area += item.get_area()
        self.unoccupied_spaces.append(Space(item_to_remove.x, item_to_remove.x + item_to_remove.width, item_to_remove.y, item_to_remove.y + item_to_remove.height))
        # self.unoccupied_spaces = rp.detect_unoccupied_areas(self.content.values(),self.width,self.height)
    
    
    def add_rectangle(self, rectangle: Rectangle) -> bool:
        if not self.can_fit(rectangle):
            return False
        new_rect_position, self.unoccupied_spaces = rp.place_rectangle(rectangle.width, rectangle.height,
                                                                       self.unoccupied_spaces)
        if new_rect_position is not None:
            # rectangle.x = new_rect_position[0]
            # rectangle.y = new_rect_position[1]
            # self.content.append(rectangle)
            self.available_area -= rectangle.get_area()
            new_rect =  Rectangle(rectangle.id,rectangle.width,rectangle.height)
            new_rect.x = new_rect_position[0]
            new_rect.y = new_rect_position[1]
            self.content[rectangle.id] = new_rect
            return True
        # else:
        #     print("No free space")
        return False

    def get_fitness(self) -> float:
        total_area = self.width * self.height
        a = (float(total_area - self.available_area) / (total_area))
        return pow(a, 2)
    


    def check_feasibility(self):
        if self.detect_overlap(self.content.values()):
            self.feasible = False
        else:
            self.feasible = True
        return self.feasible


    def __repr__(self):
        content_str = ", ".join(repr(rect) for rect in self.content.values())
        return f"Container(Content=[{content_str}])"

    @staticmethod 
    def check_overlap(rect1, rect2):
        # Check if two rectangles overlap (touching is not considered overlap)
        if (rect1.x < rect2.x + rect2.width and rect1.x + rect1.width > rect2.x and
            rect1.y < rect2.y + rect2.height and rect1.y + rect1.height > rect2.y):
            return True
        return False

    def detect_overlap(self, rectangles):
        events = []
        active_rectangles = SortedList(key=lambda x: x.y)

        # Generate events for the sweepline
        for rect in rectangles:
            events.append(('start', rect.x, rect))
            events.append(('end', rect.x+rect.width, rect))

        # Sort events, primarily by x coordinate, secondarily by type ('start' before 'end')
        events.sort(key=lambda x: (x[1], x[0] == 'end'))

        for event in events:
            _, x, rect = event
            if event[0] == 'start':
                # Check for overlap with all currently active rectangles
                for active in active_rectangles:
                    if self.check_overlap(rect, active):
                        return True
                active_rectangles.add(rect)
            else:
                active_rectangles.remove(rect)

        return False



