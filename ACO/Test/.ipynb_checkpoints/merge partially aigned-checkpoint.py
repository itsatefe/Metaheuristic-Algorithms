from sortedcontainers import SortedList
from collections import namedtuple
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle

rectangle = namedtuple('Rectangle', 'x1 x2 y1 y2')

def merge_rectangles(rectangles):
    if not rectangles:
        return []

    rectangles.sort(key=lambda r: (r.x1, r.y1))
    merged = []
    
    for current in rectangles:
        if not merged:
            merged.append(current)
            continue

        last = merged[-1]
        if last.x2 >= current.x1 and (min(last.y2, current.y2) > max(last.y1, current.y1)):
            new_x1 = min(last.x1, current.x1)
            new_x2 = max(last.x2, current.x2)
            new_y1 = max(last.y1, current.y1)
            new_y2 = min(last.y2, current.y2)
            merged[-1] = rectangle(new_x1, new_x2, new_y1, new_y2)
        else:
            merged.append(current)
    
    return merged

def process_rectangles(rectangles):
    if not rectangles:
        return []
    
    events = []
    for index, rect in enumerate(rectangles):
        events.append((rect.y1, 'start', index))
        events.append((rect.y2, 'end', index))

    events.sort(key=lambda x: (x[0], x[1] == 'start'))

    active_indices = SortedList()
    active_rectangles = []
    all_merged_rectangles = []

    last_y = None
    for y, event_type, index in events:
        if last_y is not None and y != last_y and active_rectangles:
            merged = merge_rectangles(active_rectangles)
            all_merged_rectangles.extend(merged)
            active_rectangles.clear()

        if event_type == 'start':
            active_indices.add(index)
        elif event_type == 'end':
            active_indices.remove(index)

        active_rectangles = [rectangles[i] for i in active_indices]
        last_y = y

    if active_rectangles:
        merged = merge_rectangles(active_rectangles)
        all_merged_rectangles.extend(merged)

    # Final merge to combine any remaining overlapping rectangles
    final_merged = merge_rectangles(all_merged_rectangles)
    return final_merged

def plot_rectangles(rectangles, title):
    fig, ax = plt.subplots()
    for rect in rectangles:
        ax.add_patch(Rectangle((rect.x1, rect.y1), rect.x2 - rect.x1, rect.y2 - rect.y1, edgecolor='blue', facecolor='none', linewidth=1))
    ax.set_xlim(0, 100)
    ax.set_ylim(0, 100)
    ax.set_title(title)
    plt.gca().set_aspect('equal', adjustable='box')
    plt.show()

# Example usage
rectangles = [rectangle(98, 100, 0, 100), rectangle(55, 56, 7, 100), rectangle(85, 90, 13, 100), rectangle(91, 96, 13, 100), 
              rectangle(11, 48, 16, 100), rectangle(72, 82, 19, 100), rectangle(0, 5, 21, 100), rectangle(56, 72, 22, 100),
              rectangle(48, 55, 23, 100), rectangle(96, 98, 29, 100), rectangle(5, 11, 33, 100), rectangle(90, 91, 49, 100),
              rectangle(82, 85, 65, 100)]

plot_rectangles(rectangles, 'Original Rectangles')

merged_rectangles = process_rectangles(rectangles)
plot_rectangles(merged_rectangles, 'Merged Rectangles')

for rect in merged_rectangles:
    print(f"Merged Rectangle from ({rect.x1}, {rect.x2}) to ({rect.y1}, {rect.y2})")
