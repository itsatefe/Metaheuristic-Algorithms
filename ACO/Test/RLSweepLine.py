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
class Event:
    def __init__(self, x, rect, typ):
        self.x = x
        self.rect = rect
        self.type = typ  # 'start' or 'end'

    def __lt__(self, other):
        # Change sorting logic for right-to-left processing
        return self.x > other.x or (self.x == other.x and self.type == 'end' and other.type == 'start')

class RLSweepLine:
    def __init__(self, rectangles):
        self.rectangles = rectangles

    def process_events(self, events):
        events.sort()
        active_rectangles = []
        results = []
        while events:
            event = events.pop(0)
            if event.type == 'start':  # 'end' event now signifies the start in RTL processing
                active_rectangles.append(event.rect)
            elif event.type == 'end':  # 'start' event now signifies the end
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
                results.extend(self.process_events(new_events))
                active_rectangles = new_active 
                # print(new_active)
        return results + active_rectangles

    def run(self):
        events = []
        for rect in self.rectangles:
            # Create events for the right-to-left sweep line
            events.append(Event(rect.x2, rect, 'start'))  # Now 'end' means the rectangle starts
            events.append(Event(rect.x1, rect, 'end'))  # 'start' means the rectangle ends
        return self.process_events(events)
    
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
                if i not in used:
                    new_rectangles.append(rectangles[i])
            rectangles = new_rectangles
        return rectangles + split_child

    @staticmethod
    def are_adjacent(rect1, rect2):
        # print("overlap: ",self.rectangles_overlap(rect1, rect2))
        return (rect1.y2 == rect2.y1 or rect1.y1 == rect2.y2)

    @staticmethod
    def rectangles_overlap(rect1, rect2):
        return (rect1.x1 < rect2.x2 and rect1.x2 > rect2.x1 and
                rect1.y1 < rect2.y2 and rect1.y2 > rect2.y1)
        
    @staticmethod
    def merge_rectangles(rect1, rect2):
        if rect1.width > rect2.width:
            rect1, rect2 = rect2, rect1

        merged = None
        if (rect1.x2 >= rect2.x2 and
            rect2.y1 == rect1.y1 + rect1.height):
            # print("Hiiiii ")
            new_height = rect1.height + rect2.height
            merged = Space(rect1.x1, rect1.x2, rect1.y1, rect1.y1 + new_height)
            if rect1.width != rect2.width:
                rect2.width -= rect1.width
                rect2 = Space(rect2.x1, rect2.x1+rect2.width, rect2.y1, rect2.y2)
                # rect2.x2 = rect1.x1 
            else:
                rect2 = None
        elif (rect1.x2 >= rect2.x2 and
            rect1.y1 == rect2.y1 + rect2.height):
            # print("Hiiiii ")

            new_height = rect1.height + rect2.height
            merged = Space(rect1.x1, rect1.x2, rect1.y1, rect1.y1 + new_height)
            if rect1.width != rect2.width:
                rect2.width -= rect1.width
                rect2 = Space(rect2.x1, rect2.x1 + rect2.width, rect2.y1, rect2.y2)
                # rect2.x2 = rect1.x1 
            else:
                rect2 = None
        if merged is not None:
            # print("Am i here??")
            # print("merged: ", rect1)
            # print("rect2: ", rect2)
            # print("----------------")
            
            return [merged, rect2]
        return [rect1, rect2]

