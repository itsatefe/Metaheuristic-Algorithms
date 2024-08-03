# Metaheuristic Algorithms for the Bin Packing Problem

This repository contains implementations of various metaheuristic algorithms to solve the bin packing problem. The bin packing problem involves efficiently packing a set of items of varying sizes into a finite number of bins, minimizing the number of bins used. This problem is NP-hard and has significant practical applications in logistics, manufacturing, and resource allocation.

## Table of Contents
- [Introduction](#introduction)
- [Algorithms Implemented](#algorithms-implemented)
  - [Single-Solution Based Algorithms (1D BPP)](#single-solution-based-algorithms-1d-bpp)
    - [Simulated Annealing (SA)](#simulated-annealing-sa)
    - [Tabu Search (TS)](#tabu-search-ts)
    - [Greedy Randomized Adaptive Search Procedure (GRASP)](#greedy-randomized-adaptive-search-procedure-grasp)
  - [Population-Based Algorithms (2D BPP)](#population-based-algorithms-2d-bpp)
    - [Genetic Algorithm (GA)](#genetic-algorithm-ga)
    - [Ant Colony Optimization (ACO)](#ant-colony-optimization-aco)
    - [Particle Swarm Optimization (PSO)](#particle-swarm-optimization-pso)
- [Execution Environment](#execution-environment)
- [Results](#results)


## Introduction
The bin packing problem can be formally defined as follows: given a set of items, each with a specific size, and a set of bins, each with a fixed capacity, the goal is to pack all the items into the minimum number of bins without exceeding the capacity of any bin.

## Algorithms Implemented

### Single-Solution Based Algorithms (1D BPP)
These algorithms focus on solving the one-dimensional bin packing problem by iteratively improving a single candidate solution.

#### Simulated Annealing (SA)
Simulated Annealing is inspired by the physical process of heating a material and then slowly lowering the temperature to decrease defects, thus finding a minimum energy state. The algorithm starts with a random solution and makes random changes, accepting worse solutions with a probability that decreases over time.

#### Tabu Search (TS)
Tabu Search uses a memory structure called a tabu list to store previously visited solutions to avoid cycles. It iteratively moves from one solution to another, seeking to improve while avoiding solutions on the tabu list.

#### Greedy Randomized Adaptive Search Procedure (GRASP)
GRASP is a multi-start or iterative process where each iteration consists of two phases: construction and local search. The construction phase builds a feasible solution, and the local search attempts to improve it.

### Population-Based Algorithms (2D BPP)
These algorithms are designed to solve the two-dimensional bin packing problem by evolving a population of solutions.

#### Genetic Algorithm (GA)
Genetic Algorithms are inspired by the process of natural selection. They use techniques such as selection, crossover, and mutation to evolve solutions to problems. The population of solutions evolves over generations.

#### Ant Colony Optimization (ACO)
ACO is inspired by the behavior of ants searching for food. Ants deposit pheromones on paths they travel, and these pheromones guide subsequent ants towards promising solutions.

#### Particle Swarm Optimization (PSO)
PSO is inspired by the social behavior of birds flocking or fish schooling. It optimizes a problem by iteratively improving a candidate solution with regard to a given measure of quality.

## Execution Environment
The algorithms were executed on a system with the following specifications:
- **Processor:** Intel(R) Core(TM) i7-7500U CPU @ 2.70GHz
- **Memory:** 8 GB RAM

## Results
The performance of each algorithm was evaluated based on solution quality and computational time. Detailed results and comparisons are available in the report included in this repository.
