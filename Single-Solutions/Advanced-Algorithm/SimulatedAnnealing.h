#ifndef SIMULATEDANNEALING_H
#define SIMULATEDANNEALING_H
#include "BinPacking.h"
#include "Types.h"
#include <chrono>
#include "Neighborhood.h"

using namespace std;

class SimulatedAnnealing
{
public:
	int eval_Count;
	SimulatedAnnealing(BinPacking& binPacking, ScheduleType schedule,
	                   int no_improvement_threshold, double temperature_threshold, double acceptance_rate,
	                   StopType stopType, double convergence_threshold,
	                   int no_overall_improvement_threshold, int time_limit);
	static double calculate_convergence_threshold(int numItems);
	BinPacking getBest_solution();
	vector<double> get_temperatures() ;
	void algorithm();
	vector<double> get_objectives();
	vector<double> get_differences();
	vector <vector<double>> getTweak_probabilities();
	int current_iteration; // current iteration
	int get_execution_time();
	
private:
	int execution_time;

	double convergence_threshold;
	bool stopBy_time(std::chrono::high_resolution_clock::time_point start) const;
	bool stopBy_iteration() const;
	bool stopBy_Convergence() const;
	StopType stopType;
	Neighborhood neighborhood;
	double calculate_initial_temp() const;
	double calculate_max_energy() const;
	double acceptance_rate;
	int reheating_count;
	double temperature_old;
	double cooling_factor;
	chrono::seconds loop_duration;
	vector<double> differences;
	vector <vector<double>> tweak_probabilities;
	int no_improvement_threshold;
	double calculate_temperatures(int k);
	vector<double> temperatures;
	ScheduleType schedule;
	double initial_temp;
	BinPacking binPacking;
	double logarithmic_cooling(int k) const;
	double linear_cooling(int k) const;
	double square_root_cooling(int k) const;
	double adaptive_cooling(int k);
	bool stopping_condition(std::chrono::high_resolution_clock::time_point start) const;
	BinPacking  best_solution;
	vector<double> objectives;
	bool equilibrium_condition(std::chrono::high_resolution_clock::time_point start);
	int no_improvement_count;
	double temperature_threshold;
	int no_overall_improvement_threshold;
	int no_overall_improvement_count;
};
#endif


