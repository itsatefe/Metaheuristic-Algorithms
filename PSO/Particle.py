from BinPacking import *
import random
import copy

class Particle:
    def __init__(self, containers, rectangles):
        self.positions = containers
        self.rectangles = rectangles
        # self.feasible = self.check_feasibility()
        self.feasible = True
        self.objective = None

    def __repr__(self) -> str:
        reps = ""
        for position in self.positions:
            reps += repr(position) + " "
        return reps
    
    def check_feasibility(self):
        for container in self.positions:
            if not container.check_feasibility():
                self.feasible = False
                return False
        self.feasible = True
        return True

    def objective_function(self):
        bins_fitness = sum(bin.get_fitness() for bin in self.positions)
        self.objective =  1 - (bins_fitness / len(self.positions))
        

    def update_position_reinsert(self):
        positions  = self.positions
        selected_bin = random.choice(self.positions)
        selected_item = random.choice(list(selected_bin.content.values()))
        random.shuffle(positions)  # shuffle bins for random insertion order
        for bin in positions:
            if bin.add_rectangle(selected_item):
                selected_bin.remove(selected_item)
                break
        if len(selected_bin.content) == 0:
            positions.remove(selected_bin)
        self.positions = positions

    def update_position_empty(self):
        # Step 1: Select a bin with probability weighted by available area
        # weights = [bin.available_area for bin in self.positions]
        selected_bin = random.choice(self.positions)
        self.positions.remove(selected_bin)
        # Step 2: Remove all items from the selected bin
        items_to_reinsert = list(selected_bin.content.values())
        selected_bin.content = {}  # Clear the content of the selected bin
        selected_bin.unoccupied_spaces = [Space(0,selected_bin.width,0,selected_bin.height)]
        # Step 3: Attempt to reinsert each item into the other bins
        for item in items_to_reinsert:
            reinserted = False
            random.shuffle(self.positions)  # shuffle bins for random insertion order
            for bin in self.positions:
                if bin.add_rectangle(item):
                    # Add item to the bin
                    reinserted = True
                    break
            if not reinserted:
                selected_bin.add_rectangle(item) # Re-add to the original bin if no other bin can take it
        if len(selected_bin.content) > 0:
            self.positions.append(selected_bin)


    def update_position_communication(self, bin_width,bin_height,pbest,gbest,weights ):
        list1, list2, list3 = self.positions, pbest.positions, gbest.positions
        len1 = len(list1)
        len2 = len(list2)
        len3 = len(list3)
        max_length = max(len1, len2, len3)
        result = []

        i = 0
        while  (i < len1 or i < len2 or i < len3):
            # Adjust weights only when necessary
            available_weights = []
            available_lists = []
            if i < len1:
                available_lists.append(0)
                available_weights.append(weights[0])
            if i < len2:
                available_lists.append(1)
                available_weights.append(weights[1])
            if i < len3:
                available_lists.append(2)
                available_weights.append(weights[2])
            
            # Select a list based on the adjusted weights
            chosen_list_index = random.choices(available_lists, available_weights)[0]
            # Determine which list was chosen
            if i < len1 and chosen_list_index == 0:
                result.append(list1[i])
                
            elif i < len2 and (chosen_list_index == 1 or (chosen_list_index == 0 and i >= len1)):
                result.append(list2[i])
                
            elif i < len3:
                result.append(list3[i])
            i+=1


        #remove duplicates items
        items_map = {item.id: 0 for item in self.rectangles}
        missed_items = {item.id: item for item in self.rectangles}
        result_no_dup = []
        for container in result:
            new_container_contnet = {}
            for item in container.content.values():
                items_map[item.id]+=1
                if items_map[item.id] > 1:
                    continue
                missed_items.pop(item.id)
                new_container_contnet[item.id] = item
            if len(new_container_contnet) > 0:
                new_container = Container(bin_width, bin_height, new_container_contnet)
                # if not new_container.check_feasibility():
                #     print("The bin is not feasible")
                result_no_dup.append(new_container)

        for item_id, item in missed_items.items():
            placed = False
            random.shuffle(result_no_dup)  # shuffle bins for random insertion order
            for container in result_no_dup:
            # Continue checking while there are containers to check
                if container.add_rectangle(item):
                    placed = True
                    break
            # If not placed in existing or newly checked containers, add a new one
            if not placed:
                new_container = Container(bin_width, bin_height)
                new_container.add_rectangle(item)
                result_no_dup.append(new_container)

        self.positions =  result_no_dup
        return result_no_dup

    def get_labels(self):
        labels = [-1]*len(self.rectangles)
        for container_id, container in enumerate(self.positions):
            for item_id, item in container.content.items():
                labels[item_id] = container_id
        return labels
    
    
