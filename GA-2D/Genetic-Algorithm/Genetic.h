#ifndef GENETIC_H
#define GENETIC_H
#include <vector>
#include <__msvc_chrono.hpp>

#include "Chromosome.h"
#include "Item.h"


using namespace std;

struct Parents
{
	Chromosome parent1;
	Chromosome parent2;
};


class Genetic
{
public:
	Genetic(vector<Item> items,
		int z, double epsilon, int pop_size, double init_infeasibility, double mutation_probability,
		double crossover_probability,
		double convergence_threshold,
		double elite_percentage, int tournament_size, int max_generation,
		int time_limit, int no_improvement_threshold, int eval_limit,
		SurvivalType survivalType, StopType stop_type,
		int bin_width, int bin_height, bool memetic, int best_num_bin);
	double calculate_repair_probability(std::chrono::high_resolution_clock::time_point start, int count) const;
	Chromosome repair_chromosome_semi_heuristic(Chromosome& offspring) const;
	Chromosome repair_chromosome_random(Chromosome& offspring) const;
	void algorithm();
	vector<Chromosome> feasible_initialization(int feasible_pop_size);
	Chromosome get_best_solution();
	static void display_population(vector<Chromosome>& population);
	vector<Chromosome> mating_pool_;
	vector<double> best_objectives;
	vector<double> avg_feasible_objectives;
	vector<double> all_objectives;
	int min_bins;
	vector<int> number_infeasible;
	vector<int> number_feasible;
	vector<vector<double>> tweak_probabilities;
	int execution_time;
	chrono::seconds loop_duration;
	int time_limit;
	double epsilon;
	double temp_epsilon;
	double convergence_threshold_;
	bool memetic;
	int best_num_bin;
private:
	void local_search(chrono::steady_clock::time_point start, int no_improvement_count, int& infeasible_count, int& feasible_count, vector<
		Chromosome>& new_population, double& min_value);
	double calculate_penalty_factor(std::chrono::high_resolution_clock::time_point start, int count) const;
	double init_infeasibility_;
	int calculate_min_bins();
	int current_generation_;
	SurvivalType survivalType;
	int tournament_size_;
	Chromosome best_solution_;
	Chromosome row_packing(vector<Item> items) const;
	Chromosome feasible_random_packing(vector<Item> items) const;
	Chromosome feasible_LF_packing_v2(vector<Item> items) const;
	vector<Chromosome> infeasible_initialization(int infeasible_pop_size);
	vector<Chromosome> initialize_population();
	Chromosome brute_force_packing(vector<Item> items) const;
	vector<Chromosome> select_candidates() const;
	Parents parent_selection() const;
	void elitism_selection(vector<Chromosome> new_population, const vector<Chromosome> old_population);
	void generational_selection(vector<Chromosome> new_population);
	void survival_selection(const vector<Chromosome>& new_population, const vector<Chromosome> old_population);
	bool stop_by_generation(std::chrono::high_resolution_clock::time_point start);
	bool stop_by_time(std::chrono::high_resolution_clock::time_point start);
	bool repair_chromosome(Chromosome& chromosome, std::chrono::high_resolution_clock::time_point start, int count) const;
	bool stop_by_eval_count(std::chrono::high_resolution_clock::time_point start);
	bool stop_by_convergence(int count, std::chrono::high_resolution_clock::time_point start);
	bool stopping_condition(std::chrono::high_resolution_clock::time_point start, int count);
	int no_improvement_threshold;
	int eval_limit;
	vector<Item> items_;
	int max_generation_;
	int population_size_;
	double elite_percentage_;
	double mutation_probability_;
	double crossover_probability_;
	int item_size_;
	int eval_count_;
	int z;
	int bin_width_;
	int bin_height_;
	StopType stop_type;
};

#endif
