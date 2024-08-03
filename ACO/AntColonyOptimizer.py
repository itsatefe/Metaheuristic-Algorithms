import random
import math
from typing import List, Tuple, Dict
from BinPacking import *
import copy
import time
# TODO: steps for escaping Local optima must be taken!!!
# TODO: heuristic information should be selected more carefully, now is tallest better since our feasible insert is f***ed up
# TODO: stop by time
# TODO: Config file
# .

# higher, lower max_pheromone -> more explotation, more exploration
# ------------------------------------
# higher, lower ACS_state_tranision_prob -> more exploitation, more exploration
# ------------------------------------
# higher beta, alpha -> more greedy (more sensetive), more search !!
# -------------------------------------
# number of ants -> more ant more exploration only if state transition allowes, and alpha beta
# -------------------------------------

class AntColonyOptimizer:
    def __init__(self, rectangles: List[Rectangle], container_width: int, container_height: int, alpha: float,
                 beta: float, evaporation_rate: float, ant_count: int, max_iteration: int, elit_percent: float,
                 max_duration: int, stopType: int,
                 max_pheromone: float = 10.0, min_pheromone: float = 0.005, ACS_state_tranision_prob: float = 0.9,  
                 no_imp_limit: int = 300,
                 best_num_bins: int = -1):
        self.rectangles = rectangles
        self.container_width = container_width
        self.container_height = container_height
        self.alpha = alpha
        self.beta = beta
        self.evaporation_rate = evaporation_rate
        self.ant_count = ant_count
        self.rectangles_size = len(rectangles)
        self.pheromones = [[1.0 for _ in range(self.rectangles_size)] for _ in range(self.rectangles_size)]
        # self.pheromones = [[0.5 * (min_pheromone + max_pheromone) for _ in range(self.rectangles_size)] for _ in range(self.rectangles_size)]
        self.max_iteration = max_iteration
        self.elit_percent = elit_percent
        self.max_pheromone = max_pheromone
        self.min_pheromone = min_pheromone
        self.ACS_state_tranision_prob = ACS_state_tranision_prob
        self.best_objectives = []
        self.avg_objectives = []
        self.best_solution = None
        self.max_duration = max_duration
        self.stopType = stopType
        self.no_imp_limit = no_imp_limit
        self.number_ants = []
        self.best_num_bins = best_num_bins
        self.ACS_probs = []
        self.execution_time = 0

    def run(self) -> List[Container]:
        no_imp_overall = 0
        main_ant_count = self.ant_count
        self.number_ants.append(self.ant_count)
        self.ACS_probs.append(self.ACS_state_tranision_prob)
        main_ACS_prob = self.ACS_state_tranision_prob
        best_solution = None
        best_obj = float('inf')
        solutions = []
        start_time = time.time()
        no_imp_count = 0
        for i in range(self.max_iteration):
            iteration_best = [None]*self.rectangles_size
            iteration_best_obj = float('inf')
            total_objs = 0
            self.number_ants.append(self.ant_count)
            self.ACS_probs.append(self.ACS_state_tranision_prob)
            for _ in range(self.ant_count):
                solution = self.LF_construct_solution()
                solutions.append(solution)
                solution_obj = self.objective_function(solution)
                total_objs += solution_obj
                if (iteration_best_obj > solution_obj) or (len(solution) < len(iteration_best)):
                    iteration_best = solution
                    iteration_best_obj = solution_obj
                if (solution_obj < best_obj) or (len(solution) < len(best_solution)):
                    best_solution = solution
                    best_obj = solution_obj
                    self.execution_time = int(time.time() - start_time)
                last_ant = _

                if self.stopType == 0:
                    if (time.time() - start_time > self.max_duration):
                        break
            self.best_solution = best_solution
            self.best_objectives.append(best_obj)
            self.avg_objectives.append(total_objs/(last_ant + 1))
            if i != 0:
                if abs(self.best_objectives[i-1] - self.best_objectives[i]) < 0.0001:
                    no_imp_count+=1
                else:
                    no_imp_count=0
                    no_imp_overall = 0
                    self.ant_count = main_ant_count
                    self.ACS_state_tranision_prob = main_ACS_prob
                
            if no_imp_count >= self.no_imp_limit:
                # self.ant_count += 5
                no_imp_count=0

                # self.ACS_state_tranision_prob -= 0.1
                # if self.ACS_state_tranision_prob < 0.7:
                #     self.ACS_state_tranision_prob = main_ACS_prob
                no_imp_overall += 1

            
            # print(f"size: {len(iteration_best)} , obj: {iteration_best_obj}")
            self.update_pheromones_ACS(best_solution)
            # print(self.pheromones)
            if self.stopType == 0:
                if (time.time() - start_time > self.max_duration):
                    break
            elif self.stopType == 1:
                if no_imp_overall >= 70:
                    return self.best_solution
            
            if len(self.best_solution) == self.best_num_bins:
                return self.best_solution


        return self.best_solution


    def FF_construct_solution(self) -> List[Container]:
        containers = [Container(self.container_width, self.container_height)]
        rectangles = copy.deepcopy(self.rectangles)
    
        # sorted_rectangles = sorted(rectangles, key=lambda x: x.width * x.height, reverse=True)
        sorted_rectangles = rectangles
        # first_item = sorted_rectangles.pop(0)  # Place the largest item first
        first_item = random.choice(sorted_rectangles)
        sorted_rectangles.remove(first_item)  # Remove the placed item from the list
        containers[0].add_rectangle(first_item)
        current_item = first_item
        placed_items = {current_item.id : current_item}
        # Place remaining rectangles using state transition
        while sorted_rectangles:
            next_item = self.ACS_state_transition(current_item, sorted_rectangles,containers[-1])
            if (not containers[-1].add_rectangle(next_item)):
                placed = False
                # random.shuffle(containers)

                for container in containers:
                    if container.add_rectangle(next_item):
                        placed = True
                        break
                if not placed:
                    # If it doesn't fit, start a new container
                    new_container = Container(self.container_width, self.container_height)
                    new_container.add_rectangle(next_item)
                    containers.append(new_container)
            sorted_rectangles.remove(next_item)  # Remove the placed item from the list
            current_item = next_item  # Update current item
            placed_items[current_item.id] = current_item
            
        return containers

    # Last fit
    def LF_construct_solution(self) -> List[Container]:
        containers = [Container(self.container_width, self.container_height)]
        rectangles = copy.deepcopy(self.rectangles)
        # sorted_rectangles = sorted(rectangles, key=lambda x: x.width * x.height, reverse=True)
        sorted_rectangles = rectangles
        first_item = random.choice(sorted_rectangles)
        sorted_rectangles.remove(first_item)  # Remove the placed item from the list

        containers[0].add_rectangle(first_item)
        current_item = first_item
        placed_items = {current_item.id : current_item}
        # Place remaining rectangles using state transition
        while sorted_rectangles:
            next_item = self.ACS_state_transition(current_item, sorted_rectangles,containers[-1])
            if not containers[-1].add_rectangle(next_item):
                # If it doesn't fit, start a new container
                new_container = Container(self.container_width, self.container_height)
                new_container.add_rectangle(next_item)
                containers.append(new_container)
                if containers[-1].available_area >= next_item.get_area():
                    self.pheromones[current_item.id][next_item.id] = 1e-5
                    # (0 - 0 * self.evaporation_rate) * self.pheromones[current_item.id][next_item.id]
                    self.pheromones[next_item.id][current_item.id] = self.pheromones[current_item.id][next_item.id]
            sorted_rectangles.remove(next_item)  # Remove the placed item from the list
            current_item = next_item  # Update current item
            placed_items[current_item.id] = current_item
        return containers
    
    def calculate_fit_heuristic(self, rect, container):
        remaining_space = container.available_area - rect.get_area()
        if remaining_space >= 0:
            a = (float(container.total_area - remaining_space))   
            # return pow(a, 2)
            return a
        else:
            return 1e-10

    def ACS_state_transition(self, current_item, rectangles, container):
        probabilities = {}
        total = 0
        # Evaluate each rectangle not yet placed in any container
        for rect in rectangles:
            # Retrieve pheromone level for the transition from the last placed item to this rectangle
            pheromone = self.pheromones[current_item.id][rect.id]
            tau = pheromone
            eta = self.calculate_fit_heuristic(rect,container)
            value = (tau ** self.alpha) * ((eta)  ** self.beta)
            probabilities[rect] = value
            total += value
            
        random_prob = random.random()
        chosen_rectangle = None
        if random_prob < self.ACS_state_tranision_prob:
            chosen_rectangle =  max(probabilities, key=probabilities.get)
        else:
            # Normalize probabilities
            normalized_probabilities = {key: prob / total for key, prob in probabilities.items()}
            chosen_rectangle = self.AS_state_transition(rectangles, normalized_probabilities)

        if chosen_rectangle:
            self.pheromones[current_item.id][chosen_rectangle.id] = \
            (1 - self.evaporation_rate) * self.pheromones[current_item.id][chosen_rectangle.id] + self.evaporation_rate * 1
            self.pheromones[chosen_rectangle.id][current_item.id] = self.pheromones[current_item.id][chosen_rectangle.id]
            
        return chosen_rectangle
    
    def AS_state_transition(self, rectangles, normalized_probabilities):
        # Roulette wheel selection
        choice = random.random()
        cumulative = 0
        for rect in rectangles:
            cumulative += normalized_probabilities[rect]
            if cumulative >= choice:
                return rect
        return None  # Fallback, should not happen

    def update_pheromones_ACS(self, solution: List[Container]):
        # Step 1: Evaporate pheromones for all pairs
        for i in range(self.rectangles_size):
            self.pheromones[i][i] = 0  # Set the diagonal elements to zero
            for j in range(i + 1, self.rectangles_size):  # Start from i+1 to only handle upper triangle
                self.pheromones[i][j] *= (1 - self.evaporation_rate)
                self.pheromones[j][i] = self.pheromones[i][j]  # Ensure symmetry by mirroring the value
                if self.pheromones[i][j] < self.min_pheromone:
                    self.pheromones[i][j] = self.min_pheromone
                    self.pheromones[j][i] = self.min_pheromone  # Mirror the minimum enforcement

        # Step 2: Reinforce pheromones for pairs that are in the same container
        fitness_contribution = self.evaporation_rate / ( (1-self.evaporation_rate) * self.objective_function(solution))
        for container in solution:
            rect_list = container.content
            num_rectangles = len(rect_list)
            for i in range(num_rectangles):
                rect_i = rect_list[i]
                rect_i_id = rect_i.id
                for j in range(i + 1, num_rectangles):  # Start from i+1 to only handle upper triangle
                    rect_j = rect_list[j]
                    rect_j_id = rect_j.id
                    # Reinforce pheromones for both (i, j) and (j, i)
                    self.pheromones[rect_i_id][rect_j_id] += fitness_contribution
                    self.pheromones[rect_j_id][rect_i_id] += fitness_contribution


    def update_pheromones_elist(self, solutions: List[List[Container]], elite_count: int):
        # Step 1: Evaporate pheromones for all pairs
        for i in range(self.rectangles_size):
            self.pheromones[i][i] = 0  # Set the diagonal elements to zero
            for j in range(i + 1, self.rectangles_size):  # Start from i+1 to only handle upper triangle
                self.pheromones[i][j] *= (1 - self.evaporation_rate)
                self.pheromones[j][i] = self.pheromones[i][j]  # Ensure symmetry by mirroring the value
    
        # Step 2: Identify elite solutions
        elite_solutions = sorted(solutions, key=lambda x: len(x))[:elite_count]
    
        # Step 3: Reinforce pheromones for pairs that are in the same container in elite solutions
        for solution in elite_solutions:
            fitness_contribution = 1.0 / self.objective_function(solution)
            for container in solution:
                rect_list = container.content
                num_rectangles = len(rect_list)
                for i in range(num_rectangles):
                    rect_i = rect_list[i]
                    rect_i_id = rect_i.id
                    for j in range(i + 1, num_rectangles):  # Start from i+1 to only handle upper triangle
                        rect_j = rect_list[j]
                        rect_j_id = rect_j.id
                        # Reinforce pheromones for both (i, j) and (j, i)
                        self.pheromones[rect_i_id][rect_j_id] += fitness_contribution
                        self.pheromones[rect_j_id][rect_i_id] += fitness_contribution
    
        # for i in range(self.rectangles_size):
        #     for j in range(self.rectangles_size):
        #         if self.pheromones[i][j] > self.max_pheromone:
        #             self.pheromones[i][j] = self.max_pheromone


    def update_pheromones_MMAS(self, solution: List[Container]):
           # Evaporate pheromones
        for i in range(self.rectangles_size):
            self.pheromones[i][i] = 0  # Set the diagonal elements to zero
            for j in range(i+1, self.rectangles_size):
                # Apply evaporation rate
                self.pheromones[i][j] *= (1 - self.evaporation_rate)
                self.pheromones[j][i] = self.pheromones[i][j]  # Mirror to maintain symmetry
                # Enforce minimum pheromone level
                if self.pheromones[i][j] < self.min_pheromone:
                    self.pheromones[i][j] = self.min_pheromone
                    self.pheromones[j][i] = self.min_pheromone  # Mirror the minimum enforcement

            # Reinforce pheromones based on the global best solution
            for container in solution:
                rect_list = container.content
                num_rectangles = len(rect_list)
                # Evaluate the objective function once per container
                objective_value = 1.0 / self.objective_function(solution)
                for i in range(num_rectangles):
                    rect_i = rect_list[i]
                    rect_i_id = rect_i.id
                    for j in range(i + 1, num_rectangles):
                        rect_j = rect_list[j]
                        rect_j_id = rect_j.id
                        # Update pheromone values while ensuring they do not exceed the maximum allowed level
                        updated_pheromone_value = min(self.max_pheromone, self.pheromones[rect_i_id][rect_j_id] + objective_value)
                        self.pheromones[rect_i_id][rect_j_id] = updated_pheromone_value
                        self.pheromones[rect_j_id][rect_i_id] = updated_pheromone_value


    @staticmethod
    def objective_function(containers: List[Container]):
        bins_fitness = 0
        for bin in containers:
            bins_fitness += bin.get_fitness()
        return 1 - ( bins_fitness / len(containers))