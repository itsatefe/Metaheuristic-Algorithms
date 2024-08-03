import matplotlib.pyplot as plt
import matplotlib.patches as patches

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
        return self.y > other.y or (self.y == other.y and self.type == 'start' and other.type == 'end')

class SweepLine:
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
                        upper_part = Space(rect.x1, rect.x2, event.y, rect.y2)
                        lower_part = Space(rect.x1, rect.x2, rect.y1, event.y)
                        new_active.append(upper_part)
                        # Start new sweep line for the lower part
                        new_events.extend([Event(lower_part.y2, lower_part, 'start'), Event(lower_part.y1, lower_part, 'end')])
                    else:
                        new_active.append(rect)

                results.extend(self.process_events(new_events))
                active_rectangles = new_active
        return results + self.merge_all_rectangles(active_rectangles)

    def run(self):
        events = []
        for rect in self.rectangles:
            events.append(Event(rect.y2, rect, 'start'))
            events.append(Event(rect.y1, rect, 'end'))
        self.results = self.process_events(events)
        return self.merge_all_rectangles(self.results)

    
    def merge_all_rectangles(self, rectangles):
        """ Merge all vertically adjacent rectangles """
        merged = True
        while merged:
            merged = False
            new_rectangles = []
            used = set()
            for i in range(len(rectangles)):
                if i in used:
                    continue
                for j in range(i + 1, len(rectangles)):
                    if j in used:
                        continue
                    if self.are_adjacent(rectangles[i], rectangles[j]):
                        new_rect = self.merge_rectangles(rectangles[i], rectangles[j])
                        new_rectangles.append(new_rect)
                        used.add(i)
                        used.add(j)
                        merged = True
                        break
                if i not in used:
                    new_rectangles.append(rectangles[i])
            rectangles = new_rectangles
        return rectangles

    @staticmethod
    # horizontal adjacency
    def are_adjacent(rect1, rect2):
        return (rect1.x2 == rect2.x1 or rect1.x1 == rect2.x2)

    # horizontal merge
    @staticmethod
    def merge_rectangles(rect1, rect2):
        """ Merge two vertically adjacent rectangles """
        new_x_min = min(rect1.x1, rect2.x1)
        new_x_max = max(rect1.x2, rect2.x2)
        new_y_min = min(rect1.y1, rect2.y1)
        new_y_max = max(rect1.y2, rect2.y2)
        return Space(new_x_min, new_x_max, new_y_min, new_y_max)

