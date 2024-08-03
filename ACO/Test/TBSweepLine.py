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
                print(" at y :", event.y)

                active_rectangles = new_active
        return results + active_rectangles

     
    def run(self):
        events = []
        for rect in self.rectangles:
            events.append(Event(rect.y2, rect, 'start'))
            events.append(Event(rect.y1, rect, 'end'))
        self.results = self.process_events(events)
        return self.results

     
    def merge_all_rectangles(self, rectangles):
        """ Merge all vertically adjacent rectangles """
        merged = True
        split_child = []
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
                        new_rects = self.merge_rectangles(rectangles[i], rectangles[j])
                        new_rectangles.append(new_rects[0])
                        if new_rects[1] is not None:
                            split_child.append(new_rects[1])
                        used.add(i)
                        used.add(j)
                        merged = True
                        break
                if  i not in used:
                    new_rectangles.append(rectangles[i])
            rectangles = new_rectangles
        return rectangles + split_child

    @staticmethod
    # horizontal adjacency
    def are_adjacent(rect1, rect2):
        return (rect1.x2 == rect2.x1 or rect1.x1 == rect2.x2)

    # horizontal merge
    @staticmethod
    def merge_rectangles(rect1, rect2):
        # Ensure rect1 is the smaller or equal height rectangle
        if rect1.height > rect2.height:
            rect1, rect2 = rect2, rect1  # Swap to keep rect1 as the shorter

        # if(rect1.y1 != rect2.y1):
        #     print("not equal y1")
        #     print("rect1: ", rect1)
        #     print("rect2: ", rect2)
        #     print("----------------")
        merged = None

        # Horizontal merge to the right
        if (rect1.height <= rect2.height and
             rect1.y1 == rect2.y1 and
               rect2.x1 == rect1.x1 + rect1.width):
            new_width = rect1.width + rect2.width
            merged = Space(rect1.x1, rect1.x1 + new_width, rect1.y1 , rect1.y1 + rect1.height)
            if rect1.height != rect2.height:
                rect2.height -= rect1.height
                rect2 = Space(rect2.x1,rect2.x2, rect1.y2, rect1.y2 + rect2.height)
                # rect2.y1 += rect1.height
                # rect2.y2 = rect2.y1 + rect2.height

            else:
                rect2 = None

        # Horizontal merge to the left
        elif (rect1.height <= rect2.height and
            rect1.y1 == rect2.y1 and
            rect1.x1 == rect2.x1 + rect2.width):
            new_width = rect1.width + rect2.width
            merged = Space(rect2.x1, rect2.x1+ new_width,rect1.y1,rect1.y1 + rect1.height)
            if rect1.height != rect2.height:
                rect2.height -= rect1.height
                rect2 = Space(rect2.x1,rect2.x2, rect1.y2, rect1.y2 + rect2.height)
            else:
                rect2 = None

        if merged is not None:
            return [merged, rect2]  # Return the merged rectangle and the potentially modified rect2
        return [rect1, rect2]  # No merging occurred

