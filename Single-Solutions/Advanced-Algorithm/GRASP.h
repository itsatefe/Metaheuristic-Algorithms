#ifndef GRASP_H
#define GRASP_H
#include <any>
#include <chrono>
#include <unordered_map>
#include "BinPacking.h"
#include "Types.h"

struct Local_Result
{
	BinPacking binPacking;
	int execution_time;
};

enum LocalSearch
{
	Hill_Climbing,
	Tabu_Search,
	Simulated_Annealing
};

class GRASP
{
public:
	GRASP(BinPacking& binPacking, LocalSearch localSearch, StopType stopType,
		double heuristic_probability, double alpha, int no_improvement_threshold, int time_limit);
	int eval_Count;
	unordered_map<string, any> local_CONFIG;
	int alpha_adjust_count;
	int local_time;

	void algorithm();
	bool stopBy_time(std::chrono::high_resolution_clock::time_point start) const;
	bool stopping_condition(std::chrono::high_resolution_clock::time_point start, int count);
	bool stopBy_Convergence(int count, std::chrono::high_resolution_clock::time_point start) const;
	bool stopBy_iteration() const;
	BinPacking getBest_solution();
	int get_execution_time() const;
	vector<double> get_objectives();
	vector<double> get_temperatures();
	vector<vector<double>> getTweak_probabilities();
private:
	vector<double> temperatures;
	int getNextBinId();
	int max_bin_id;
	void adapt_parameters(int count);
	unordered_map<int, Item> shuffle_items();
	BinPacking construction_phase();
	int greedy_function(unordered_map<int, Bin>& bins, Item& item);
	vector<double> objectives;
	Local_Result HC_phase(BinPacking current_binPacking); // hill climbing
	Local_Result TS_phase(BinPacking current_binPacking); // tabu search
	Local_Result SA_phase(BinPacking current_binPacking); // simulated annealing
	vector<Bin> best_fit(const unordered_map<int, Bin>& bins, const Item& item);
	vector<Bin> first_fit(unordered_map<int, Bin> bins, Item item);
	Item select_candidate();
	vector<Bin> RCL_maker(unordered_map<int, Bin> bins, Item item, double calc_alpha);
	void calculate_alpha();
	Bin createNewBin();
	vector<Item> value_based_RCL();
	vector<Item> rank_based_RCL();

	Local_Result local_search(BinPacking current_binPacking);
	int no_improvement_count;
	int no_improvement_threshold;
	BinPacking best_binPacking;
	LocalSearch localSearch;
	double alpha;
	StopType stopType;
	int execution_time;
	BinPacking first_binPacking;
	int current_iteration;
	chrono::seconds loop_duration;
	double heuristic_probability;
	vector<vector<double>> tweak_probabilities;
};
#endif
