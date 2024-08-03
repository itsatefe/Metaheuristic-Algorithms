from BinPacking import *
from collections import defaultdict
from typing import List, Dict, Tuple
import copy
from Utility import *
import time
from sklearn.metrics import normalized_mutual_info_score
from Particle import *
from PSO import *


#TODO: plot islands objective separately
#TODO: migration based on no improvment count - if no improvement, increase migration
#TODO: number of particles based on number of rectangles?? more rectangle less particle???
#TODO: NMI for measuring diversity 
#TODO: diverse particles within sub-swarm


class IslandPSO:
    def __init__(self, num_particles, num_islands, max_iteration, island_iteration, rectangles, w, c1, c2, bin_width,
                  bin_height, migration_interval,no_improvement, max_duration, stop_by_time =  False, best_value:int= -1):
        self.num_islands = num_islands
        self.num_particles = num_particles
        self.rectangles =  rectangles
        self.max_iteration = max_iteration
        self.w = w
        self.c1 = c1
        self.c2 = c2
        self.bin_width = bin_width
        self.bin_height = bin_height
        self.stop_by_time = stop_by_time
        self.max_duration = max_duration
        self.migration_interval = migration_interval
        self.global_best = None
        self.global_best_fitness = float('inf') 
        self.avg_objectives = []
        self.best_objectives = []
        self.detailed_objectives = []
        self.diversity = [[0] * self.num_particles for _ in range(self.num_particles)]
        self.island_iteration = island_iteration
        self.no_improvement = no_improvement
        self.execution_time = 0
        self.best_value = best_value

    def migrate(self, islands):
        if len(islands) ==  1:
            return islands
        for i in range(self.num_islands):
            donor_index = (i + 1) % self.num_islands
            recipient_island = islands[i]
            donor_island = islands[donor_index]
            recipient_island.particles[-1], donor_island.particles[-1] = donor_island.particles[-1], recipient_island.particles[-1]
        return islands
  

    def update_global_best(self, islands, start_time):
        for island in islands:
            island_best = island.gbest
            if island_best.objective < self.global_best_fitness or len(island_best.positions) < len(self.global_best.positions) :
                self.global_best_fitness = island_best.objective
                self.global_best = copy.copy(island_best)
                # print("global best: ", len(island_best.positions))
                self.execution_time = time.time() - start_time 
                

    def run(self):
        start_time = time.time()

        for iteration in range(self.max_iteration):
            if iteration == 0:
                islands = [PSO(self.num_particles // self.num_islands, self.island_iteration, self.no_improvement * (self.num_particles // self.num_islands), self.rectangles, self.w, self.c1, self.c2, self.bin_width, self.bin_height, self.best_value) for _ in range(self.num_islands)]
            else:
                particles = [island.particles for island in islands]
                islands = [PSO(self.num_particles // self.num_islands, self.island_iteration, self.no_improvement * (self.num_particles // self.num_islands) , self.rectangles, self.w, self.c1, self.c2, self.bin_width, self.bin_height, self.best_value, particles[_], self.global_best) for _ in range(self.num_islands)]

            if iteration % self.migration_interval == 0:
                islands = self.migrate(islands)
            total_avg_objectives = 0
            objectives_per_island = []
            for i, island in enumerate(islands):
                island.run()
                objectives_per_island.append((island.avg_objectives,island.best_objectives))
                total_avg_objectives += sum(island.avg_objectives) / island.last_iteration         
                island_best = island.gbest
                if self.global_best is None:
                    self.global_best = island_best
            self.update_global_best(islands, start_time)
                
            # if iteration == self.max_iteration - 1 and not self.stop_by_time:
            #     self.calculate_diversity(islands)
            

            self.detailed_objectives.append(objectives_per_island)
            self.best_objectives.append(self.global_best.objective)                
            self.avg_objectives.append(total_avg_objectives/self.num_islands) 
            if self.stop_by_time and (time.time() - start_time > self.max_duration):
                print(f"execution time {time.time() - start_time}")
                # self.calculate_diversity(islands)
                print(f"iteration: {iteration}")
                break

            if len(self.global_best.positions) == self.best_value:
                break

    def calculate_diversity(self,islands):
        particles_labels = []
        for i, island in enumerate(islands):
            for particle in island.particles:
                labels = particle.get_labels()
                particles_labels.append(labels)

        for i in range(self.num_particles):
            for j in range(i+1 , self.num_particles):
                nmi_score = normalized_mutual_info_score(particles_labels[i], particles_labels[j])
                self.diversity[i][j] = 1 - nmi_score
                self.diversity[j][i] = 1 - nmi_score
    

