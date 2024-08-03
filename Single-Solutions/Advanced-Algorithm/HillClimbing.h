#ifndef HILLCLIMIBING_H
#define HILLCLIMBING_H
#include <chrono>

#include "BinPacking.h"
#include "Neighborhood.h"
#include "Types.h"

class HillClimbing
{
public:
	HillClimbing(BinPacking& binPacking,
		int no_improvement_threshold,
		StopType stopType,
		int tweaksCount,
		int time_limit);
	void algorithm();
	BinPacking getBest_solution();
	vector<double> get_objectives();
	vector<vector<double>> getTweak_probabilities();
	int eval_Count;
	int current_iteration;
	int no_improvement_count;
	int get_execution_time() const;

private:
	int execution_time;

	vector<vector<double>> tweak_probabilities;
	vector<double> objectives;
	chrono::seconds loop_duration;
	static double calculate_convergence_threshold(int numItems);
	bool stopBy_time(std::chrono::high_resolution_clock::time_point start) const;
	bool stopping_condition(std::chrono::high_resolution_clock::time_point start, int count) const;
	bool stopBy_Convergence(int count, std::chrono::high_resolution_clock::time_point start) const;
	bool stopBy_iteration() const;
	int no_improvement_threshold;
	StopType stopType;
	BinPacking first_binPacking;
	BinPacking best_solution;
	double convergence_threshold;
	Neighborhood neighborhood;
	int tweaksCount;
};
#endif
