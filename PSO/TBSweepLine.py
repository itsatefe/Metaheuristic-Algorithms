import matplotlib.pyplot as plt
import matplotlib.patches as patches
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



# top-bottom sweep line
# for times that our item
# is wide
class Event:
    def __init__(self, y, rect, typ):
        self.y = y
        self.rect = rect
        self.type = typ  # 'start' or 'end'

    def __lt__(self, other):
        return self.y > other.y or (self.y == other.y and self.type == 'end' and other.type == 'start')

class TBSweepLine:
    def __init__(self, rectangles):
        self.rectangles = rectangles
        self.results = []

     
    def process_events(self, events):
        events.sort()
        active_rectangles = []
        results = []
        while events:
            event = events.pop(0)
            if event.type == 'start':
                active_rectangles.append(event.rect)
            elif event.type == 'end':
                new_active = []
                new_events = []
                for rect in active_rectangles:
                    if rect.y1 < event.y < rect.y2:
                        # Split the Space
                        upper_part = Space(rect.x1, rect.x2, event.y,  rect.y2)
                        lower_part = Space(rect.x1, rect.x2, rect.y1, event.y)
                        new_active.append(upper_part)
                        # Start new sweep line for the lower part
                        new_events.extend([Event(lower_part.y2, lower_part, 'end'), Event(lower_part.y1, lower_part, 'start')])
                    else:
                        new_active.append(rect)
                results.extend(self.process_events(new_events))
                # print("--------------------------------at y :", event.y)

                active_rectangles = new_active
        return results + active_rectangles

     
    def run(self):
        events = []
        for rect in self.rectangles:
            events.append(Event(rect.y2, rect, 'start'))
            events.append(Event(rect.y1, rect, 'end'))
        self.results = self.process_events(events)
        return self.results
