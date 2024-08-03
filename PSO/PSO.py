from BinPacking import *
import random
from typing import List, Dict, Tuple
import copy
from Utility import *
from Particle import *
# w + c1 + c2 = 1
#particle, pbest, gbest
class PSO:
    def __init__(self, num_particles: int,max_iteration:int,no_improvement:int, rectangles: List[Rectangle], w:float, c1:float, c2:float, bin_width:int, bin_height:int,best_value:int, particles=None, gbest=None) -> None:
        self.rectangles = rectangles
        self.weights = [w,c1,c2]
        self.bin_height = bin_height
        self.bin_width = bin_width
        self.num_particles = num_particles
        if particles is None:
            self.particles = self.initialize_particles(num_particles)
        else:
            self.particles = particles
        self.min_bins = sum([rect.area for rect in rectangles ]) / (bin_height * bin_width)
        if gbest is None:
            self.gbest = copy.copy(min(self.particles, key=lambda obj: (len(obj.positions), obj.objective)))
        else:
            self.gbest = copy.copy(gbest)
        self.max_iteration = max_iteration
        self.best_objectives = []
        self.avg_objectives = []
        self.pbests = self.initialize_pbest()
        self.last_iteration = max_iteration
        self.no_imporovement = no_improvement
        self.best_value = best_value

    def initialize_pbest(self):
        pbests = []
        for particle in self.particles:
            new_pbest = Particle(particle.positions,self.rectangles)
            new_pbest.objective = particle.objective
            pbests.append(new_pbest)
        return pbests
        
    def update_pbest(self,particle, i):
        self.pbests[i] = Particle(particle.positions,self.rectangles)
        self.pbests[i].objective = particle.objective

    def initialize_particles(self, num_particles) -> List[Particle]:
        particles = []
        
        for _ in range(num_particles):
            random_containers = self.LF_construct_solution()
            new_particle = Particle(random_containers,self.rectangles)
            new_particle.objective_function()
            particles.append(new_particle)
        return particles

    
    def run(self):
        particles = self.particles
        no_imp_count = 0
        for iteration in range(self.max_iteration):
            total_objectives = 0
            new_particles = [None]*len(particles)
            for i,particle in enumerate(particles):
                # particle.update_position_empty()
                # particle.update_position_reinsert()
                containers = particle.update_position_communication(self.bin_width,self.bin_height,self.pbests[i],self.gbest,self.weights)
                particle.objective_function()
                total_objectives += particle.objective
                self.update_pbest(particle,i)
                if self.update_gbest(particle):
                    no_imp_count = 0
                else:
                    no_imp_count += 1
                new_particle = Particle(containers,particle.rectangles)
                new_particle.objective = particle.objective
                new_particles[i] = new_particle
            particles = new_particles
            self.best_objectives.append(self.gbest.objective)
            self.avg_objectives.append(total_objectives/self.num_particles)
            if no_imp_count >= self.no_imporovement:
                self.last_iteration = iteration
                break
            if self.best_value == len(self.gbest.positions):
                break
        self.particles = particles        


    def update_gbest(self, particle):
        if len(particle.positions) < len(self.gbest.positions) or self.gbest.objective > particle.objective:
            # print("gbest: ", len(particle.positions))
            self.gbest = copy.copy(particle)
            return True
        return False

        
    def LF_construct_solution(self) -> List[Container]:
        containers = [Container(self.bin_width, self.bin_height)]
        shuffled_rectangles = self.rectangles[:]
        random.shuffle(shuffled_rectangles)
        for next_item in shuffled_rectangles:
            if not containers[-1].add_rectangle(next_item):
                new_container = Container(self.bin_width, self.bin_height)
                new_container.add_rectangle(next_item)
                containers.append(new_container)
        return containers
    

    def FF_construct_solution(self) -> List[Container]:
        containers = [Container(self.bin_width, self.bin_height)]
        shuffled_rectangles = self.rectangles[:]
        random.shuffle(shuffled_rectangles)
        for next_item in shuffled_rectangles:
            if not containers[-1].add_rectangle(next_item):
                placed = False
                random.shuffle(containers)
                for container in containers:
                    if container.add_rectangle(next_item):
                        placed = True
                        break
                if not placed:
                    # If it doesn't fit, start a new container
                    new_container = Container(self.bin_width, self.bin_height)
                    new_container.add_rectangle(next_item)
                    containers.append(new_container)
        return containers
