#include "TabuSearch.h"
#include <cmath>
#include <chrono>
#include <random>
#include "TabuList.h"
#include <tuple>
#include "Neighborhood.h"
#include <random>
#include <set>

TabuSearch::TabuSearch(BinPacking& binPacking,
                       int no_improvement_threshold,
                       StopType stopType,
                       double convergence_threshold,
                       int time_limit,
                       int tabuSize,
                       int tweaksCount
) : best_solution(binPacking), stopType(stopType), first_binPacking(binPacking), tabuSize(tabuSize),
    tabuList(tabuSize)
{
	this->no_improvement_threshold = no_improvement_threshold;
	this->current_iteration = 1;
	this->loop_duration = chrono::seconds(time_limit);
	this->no_improvement_count = 0;
	this->tweaksCount = tweaksCount;
	this->eval_Count = 0;
	this->no_improvement_count = 0;
	this->convergence_threshold = calculate_convergence_threshold(first_binPacking.getItems_size());
}

double TabuSearch::calculate_convergence_threshold(int numItems)
{
	if (numItems <= 150)
	{
		return 0.0001; // Higher threshold for less complex problems
	}
	if (numItems <= 500)
	{
		return 0.00008; // Medium threshold for moderately complex problems
	}
	return 0.0000001; // Lower threshold for more complex problems
}

bool TabuSearch::stopping_condition(std::chrono::high_resolution_clock::time_point start, int count)
{
	switch (stopType)
	{
	case timeLimit:
		return this->stopBy_time(start);
		break;
	case iteration:
		return this->stopBy_iteration();
		break;
	case convergence:
		return this->stopBy_Convergence(count, start);
		break;
	default:
		return false;
	}
}

bool TabuSearch::stopBy_Convergence(int count, std::chrono::high_resolution_clock::time_point start)
{
	if (count >= 25)
	{
		cout << count << ": count" << '\n';
		auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start)).
			count();
		cout << "exit time: " << stop << '\n';
		//this->execution_time = static_cast<int>(stop);
		return true;
	}

	if (const int max_iteration = first_binPacking.getMax_iteration(); current_iteration >= max_iteration)
	{
		auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start)).
			count();
		cout << "exit time: " << stop << '\n';
		//this->execution_time = static_cast<int>(stop);
		return true;
	}

	return false;
}

bool TabuSearch::stopBy_iteration() const
{
	if (current_iteration >= first_binPacking.getMax_iteration()) return true;
	return false;
}

bool TabuSearch::stopBy_time(std::chrono::high_resolution_clock::time_point start) const
{
	if (chrono::high_resolution_clock::now() - start < loop_duration)
		return false;
	auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start));
	/*cout << "exit time: " << stop << '\n';
	cout << "last iteration: " << current_iteration << '\n';*/
	return true;
}

int TabuSearch::calculate_tenure_based_on_quality() const
{
	if (no_improvement_count >= no_improvement_threshold)
	{
		return static_cast<int>(std::ceil(tabuSize * 1.5));
	}

	return tabuSize;
}

bool move(bool next_in_tabuList, bool current_in_tabuList, bool is_worse, bool is_best)
{
	if (is_best) return true;
	return (!next_in_tabuList) && (current_in_tabuList || is_worse);
}

void TabuSearch::algorithm()
{
	//random_device rd;
	//mt19937 gen(rd());
	//uniform_real_distribution<> dis(0.0, 1.0);
	vector<double> probabilities(neighborhood.tweak_numbers, 1 / static_cast<double>(neighborhood.tweak_numbers));
	neighborhood.setTweak_probabilities(probabilities);
	tweak_probabilities.push_back(probabilities);
	bool stopped = false;
	auto start = chrono::high_resolution_clock::now();
	double first_objective = first_binPacking.objective_function();
	eval_Count++;
	objectives.push_back(first_objective);
	BinPacking current_binPacking = first_binPacking;
	int count = 0;
	while (!stopped)
	{
		//tabuList.display();
		vector<int> nReward(neighborhood.tweak_numbers, 0);
		vector<int> nPenalty(neighborhood.tweak_numbers, 0);
		FunctionID selectedFunctionID = neighborhood.select_tweak();
		Result temp_result = neighborhood.call_tweak(selectedFunctionID, current_binPacking);
		double temp_objective = temp_result.binPacking.get_objective();
		//current_result.first_binPacking.displayBins();
		//objectives.push_back(current_objective);
		eval_Count++;
		//double old_objective = current_objective;
		for (int i = 0; i < tweaksCount; i++)
		{
			selectedFunctionID = neighborhood.select_tweak();
			Result next_result = neighborhood.call_tweak(selectedFunctionID, current_binPacking);
			double next_objective = next_result.binPacking.get_objective();
			eval_Count++;
			bool next_in_tabuList = tabuList.is_tabu(next_result.changes);
			bool temp_in_tabuList = tabuList.is_tabu(temp_result.changes);
			bool is_worse = temp_objective > next_objective;
			bool is_best = next_objective < best_solution.get_objective();
			if (move(next_in_tabuList, temp_in_tabuList, is_worse, is_best))
			{
				nReward[selectedFunctionID] += 1;
				temp_result = next_result;
				no_improvement_count = 0;
				objectives.push_back(next_objective);
				if (is_best)
				{
					best_solution = next_result.binPacking;
					auto stop = std::chrono::duration_cast<std::chrono::seconds>(
							(chrono::high_resolution_clock::now() - start)).
						count();
					this->execution_time = static_cast<int>(stop);
				}
			}
			else
			{
				no_improvement_count++;
				nPenalty[selectedFunctionID] += 1;
			}
			current_iteration++;
		}
		double difference = temp_result.binPacking.get_objective() - current_binPacking.get_objective();
		if (abs(difference) < convergence_threshold)
		{
			count++;
		}
		else
		{
			count = 0;
		}

		bool temp_inTabu = tabuList.is_tabu(temp_result.changes);
		temp_objective = temp_result.binPacking.get_objective();
		BinPacking temp_binPacking = temp_result.binPacking;

		if (current_binPacking.get_objective() > temp_objective && !temp_inTabu)
		{
			int tabu_maxSize = calculate_tenure_based_on_quality();
			addToTabuList(temp_result.changes, tabu_maxSize);
			tabu_tenures.push_back(tabu_maxSize);
			current_binPacking = temp_binPacking;
		}
		double best_objective = best_solution.get_objective();

		if (best_objective > current_binPacking.get_objective())
		{
			best_solution = current_binPacking;
			auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start))
				.
				count();
			this->execution_time = static_cast<int>(stop);
		}
		for (int i = 0; i < neighborhood.tweak_numbers; i++)
		{
			neighborhood.RD[i].push_back(nReward[i]);
			neighborhood.PN[i].push_back(nPenalty[i]);
		}

		probabilities = neighborhood.reassign_probabilities();
		neighborhood.setTweak_probabilities(probabilities);
		tweak_probabilities.push_back(probabilities);
		stopped = stopping_condition(start, count);
		/*cout << "count: " << count << '\n';
		cout << "current iteration: " << current_iteration << '\n';*/
	}
	cout << "last iteration: " << current_iteration << '\n';
}

void TabuSearch::addToTabuList(const vector<tuple<int, int, int>>& tuples, int tabu_maxSize)
{
	tabuList.setMaxTabuSize(tabu_maxSize);
	for (tuple t : tuples)
	{
		int item_id = get<0>(t);
		int from_bin = get<1>(t);
		int to_bin = get<2>(t);
		tabuList.put(item_id, from_bin, to_bin);
	}
}

bool containsTuple(const std::vector<std::tuple<int, int>>& vec, const std::tuple<int, int>& t)
{
	return std::find(vec.begin(), vec.end(), t) != vec.end();
}

BinPacking TabuSearch::getBest_solution()
{
	return best_solution;
}

vector<double> TabuSearch::get_objectives()
{
	return objectives;
}

vector<vector<double>> TabuSearch::getTweak_probabilities()
{
	return tweak_probabilities;
}

bool TabuSearch::aspiration_criteria(bool next_in_tabuList, bool current_in_tabuList,
                                     bool is_worse, double next_cost, double best_cost, double epsilon)
{
	if (!next_in_tabuList)
	{
		return true;
	}

	if (next_cost < best_cost)
	{
		return true;
	}

	if (next_cost <= best_cost + epsilon)
	{
		return true;
	}

	if (current_in_tabuList && !is_worse)
	{
		return true;
	}

	return false;
}

int TabuSearch::calculate_tenure_based_on_difference(double difference)
{
	cout << "log difference: " << std::log(std::abs(difference) + 1) << "\n";
	double dynamicTenure = 7 * 1000 * std::log(std::abs(difference) + 1);

	dynamicTenure = std::max(2.0, dynamicTenure);
	dynamicTenure = std::min(20.0, dynamicTenure);
	return static_cast<int>(dynamicTenure);
}

vector<int> TabuSearch::get_tabuTenures()
{
	return tabu_tenures;
}

int TabuSearch::get_execution_time()
{
	return execution_time;
}
