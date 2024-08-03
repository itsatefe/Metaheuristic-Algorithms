class Interval:
    def __init__(self, low, high, rect=None):
        self.low = low
        self.high = high
        self.rect = rect

    def __lt__(self, other):
        return self.low < other.low

    def __eq__(self, other):
        if not other:
            return False
        return self.low == other.low and self.high == other.high and self.rect == other.rect


class Node:
    def __init__(self, interval):
        self.interval = interval
        self.max = interval.high
        self.left = None
        self.right = None


class IntervalTree:
    def __init__(self):
        self.root = None

    def insert(self, node, interval, ignore=None):
        if node is None:
            return Node(interval)

        if interval.low < node.interval.low:
            node.left = self.insert(node.left, interval, ignore)
        else:
            node.right = self.insert(node.right, interval, ignore)

        node.max = max(node.max, interval.high)
        return node

    def delete_node(self, node, interval):
        if node is None:
            return None

        if interval.low < node.interval.low:
            node.left = self.delete_node(node.left, interval)
        elif interval.low > node.interval.low:
            node.right = self.delete_node(node.right, interval)
        else:
            if node.left is None:
                return node.right
            elif node.right is None:
                return node.left

            temp = self.min_value_node(node.right)
            node.interval = temp.interval
            node.right = self.delete_node(node.right, temp.interval)

        if node:
            node.max = max(node.interval.high, self.get_max(node.left), self.get_max(node.right))
        return node

    def min_value_node(self, node):
        current = node
        while current and current.left is not None:
            current = current.left
        return current

    def do_overlap(self, i1, i2):
        return i1.low < i2.high and i2.low < i1.high


    def overlap_search(self, node, interval, ignore=None):
        if node is None:
            return False, None

        if node.interval != ignore and self.do_overlap(node.interval, interval):
            return True, node.interval.rect

        if node.left is not None and node.left.max > interval.low:
            found, rect = self.overlap_search(node.left, interval, ignore)
            if found:
                return True, rect

        return self.overlap_search(node.right, interval, ignore)

    def get_max(self, node):
        if node is None:
            return float('-inf')
        return node.max

    def get_intervals(self, node):
        intervals = []
        if node:
            intervals.append((node.interval.low, node.interval.high))
            intervals.extend(self.get_intervals(node.left))
            intervals.extend(self.get_intervals(node.right))
        return intervals

    def insert_interval(self, interval):
        # Check for overlaps, ignoring the new interval itself
        # if self.overlap_search(self.root, interval, interval):
        #     print("Overlap detected with another interval.")
        #     return
        self.root = self.insert(self.root, interval, interval)

    def remove_interval(self, interval):
        self.root = self.delete_node(self.root, interval)

    def search_overlap(self, interval):
        return self.overlap_search(self.root, interval)

    def list_intervals(self):
        return self.get_intervals(self.root)
