import matplotlib.pyplot as plt
import matplotlib.patches as patches
from collections import deque

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

class Event:
    def __init__(self, x, rect, typ):
        self.x = x
        self.rect = rect
        self.type = typ  # 'start' or 'end'

    def __lt__(self, other):
        return self.x > other.x or (self.x == other.x and self.type == 'end' and other.type == 'start')

class RLSweepLine:
    def __init__(self, rectangles):
        self.rectangles = rectangles

    def process_events(self, events):
        events = deque(sorted(events))  # Sort events and convert to deque
        active_rectangles = []
        results = []
        while events:
            event = events.popleft()  # Efficient pop from the front
            if event.type == 'start':
                active_rectangles.append(event.rect)
            elif event.type == 'end':
                new_active = []
                new_events = []
                for rect in active_rectangles:
                    if rect.x1 < event.x < rect.x2:
                        # Split the rectangle for right-to-left processing
                        right_part = Space(event.x, rect.x2, rect.y1, rect.y2)
                        left_part = Space(rect.x1, event.x, rect.y1, rect.y2)
                        new_active.append(right_part)
                        # Start new sweep line for the left part
                        new_events.extend([Event(left_part.x2, left_part, 'start'), Event(left_part.x1, left_part, 'end')])
                    else:
                        new_active.append(rect)
                events.extend(sorted(new_events))  # Sort and extend the events deque
                active_rectangles = new_active
        return results + active_rectangles

    def run(self):
        events = []
        for rect in self.rectangles:
            # Create events for the right-to-left sweep line
            events.append(Event(rect.x2, rect, 'start'))
            events.append(Event(rect.x1, rect, 'end'))
        return self.process_events(events)
