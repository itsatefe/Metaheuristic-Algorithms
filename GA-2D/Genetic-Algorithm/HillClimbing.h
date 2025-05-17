#ifndef HILLCLIMBING_H
#define HILLCLIMBING_H
#include <chrono>

#include "Chromosome.h"
#include "Types.h"

using namespace std;

class HillClimbing
{
public:
	HillClimbing(const Chromosome& offspring, int max_iteration, int no_improvement_threshold, int tweaks_count, double penalty_factor);
	void algorithm();
	Chromosome getBest_solution();
	vector<double> get_objectives();
	vector<vector<double>> getTweak_probabilities();
	int eval_Count;
	int current_iteration;
	int no_improvement_count;
	double penalty_factor;
	int get_execution_time() const;

private:
	double calculate_penalty_factor(int count) const;
	int execution_time;
	vector<vector<double>> tweak_probabilities;
	vector<double> objectives;
	//chrono::seconds loop_duration;
	//static double calculate_convergence_threshold(int numItems);
	//bool stopBy_time(std::chrono::high_resolution_clock::time_point start) const;
	bool stopping_condition(int count) const;
	bool stopBy_Convergence(int count) const;
	//bool stopBy_iteration() const;
	int no_improvement_threshold;
	//StopType stopType;
	Chromosome best_solution;
	Chromosome first_solution;
	double convergence_threshold;
	int tweaks_count;
	int max_iteration;
};
#endif
