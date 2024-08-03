#include "HillClimbing.h"
#include <chrono>
#include "Neighborhood.h"
#include "TabuSearch.h"

using namespace std;

HillClimbing::HillClimbing(BinPacking& binPacking, int no_improvement_threshold, StopType stopType
	, int tweaksCount, int time_limit) : first_binPacking(binPacking),
	best_solution(binPacking)
{
	this->no_improvement_count = 0;
	this->execution_time = 0;
	this->current_iteration = 1;
	this->no_improvement_threshold = no_improvement_threshold;
	this->stopType = stopType;
	this->convergence_threshold = calculate_convergence_threshold(first_binPacking.getItems_size());
	this->tweaksCount = tweaksCount;
	this->loop_duration = chrono::seconds(time_limit);
	this->eval_Count = 0;
}

double HillClimbing::calculate_convergence_threshold(int numItems)
{
	if (numItems <= 150)
	{
		return 0.0002;
	}
	if (numItems <= 500)
	{
		return 0.00005;
	}
	return 0.00001;
}

bool HillClimbing::stopping_condition(std::chrono::high_resolution_clock::time_point start, int count) const
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

bool HillClimbing::stopBy_Convergence(int count, std::chrono::high_resolution_clock::time_point start) const
{
	if (count >= 25)
	{
		//cout << count << ": count" << '\n';
		auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start)).
			count();
		//cout << "exit time: " << stop << '\n';
		//this->execution_time = static_cast<int>(stop);
		return true;
	}

	if (const int max_iteration = first_binPacking.getMax_iteration(); current_iteration >= max_iteration)
	{
		auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start)).
			count();
		//cout << "exit time: " << stop << '\n';
		//this->execution_time = static_cast<int>(stop);
		return true;
	}

	return false;
}

bool HillClimbing::stopBy_iteration() const
{
	if (current_iteration >= first_binPacking.getMax_iteration()) return true;
	return false;
}

bool HillClimbing::stopBy_time(std::chrono::high_resolution_clock::time_point start) const
{
	if (chrono::high_resolution_clock::now() - start < loop_duration)
		return false;
	auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start));
	/*cout << "exit time: " << stop << '\n';
	cout << "last iteration: " << current_iteration << '\n';*/
	return true;
}

void HillClimbing::algorithm()
{
	double current_objective = first_binPacking.get_objective();
	//cout << "- current_objective: " << current_objective << '\n';
	BinPacking current_binPacking = first_binPacking;
	double next_objective = 1.0;

	vector<double> probabilities(neighborhood.tweak_numbers, 1 / static_cast<double>(neighborhood.tweak_numbers));
	neighborhood.setTweak_probabilities(probabilities);
	tweak_probabilities.push_back(probabilities);
	bool stopped = false;
	auto start = chrono::high_resolution_clock::now();
	int count = 0;
	while (!stopped)
	{
		vector<int> nReward(neighborhood.tweak_numbers, 0);
		vector<int> nPenalty(neighborhood.tweak_numbers, 0);
		for (int i = 0; i < tweaksCount; i++)
		{
			FunctionID selectedFunctionID = neighborhood.select_tweak();
			Result next_result = neighborhood.call_tweak(selectedFunctionID, current_binPacking);
			next_objective = next_result.binPacking.get_objective();
			eval_Count++;
			if (next_objective < current_objective)
			{
				nReward[selectedFunctionID] += 1;
				no_improvement_count = 0;
				objectives.push_back(next_objective);
				current_objective = next_objective;
				current_binPacking = next_result.binPacking;
				break;
			}
			no_improvement_count++;
			nPenalty[selectedFunctionID] += 1;
		}
		if (no_improvement_count >= no_improvement_threshold)
		{
			count++;
		}
		else
		{
			count = 0;
		}
		if (current_objective < best_solution.get_objective())
		{
			best_solution = current_binPacking;
			auto stop = std::chrono::duration_cast<std::chrono::seconds>(
				(chrono::high_resolution_clock::now() - start)).
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
		current_iteration++;
		stopped = stopping_condition(start, count);
		//cout << "- no improvement counter: " << count << '\n';
	}
	//cout << "- execution time: " << execution_time << '\n';
}

BinPacking HillClimbing::getBest_solution()
{
	return best_solution;
}

vector<double> HillClimbing::get_objectives()
{
	return objectives;
}

vector<vector<double>> HillClimbing::getTweak_probabilities()
{
	return tweak_probabilities;
}

int HillClimbing::get_execution_time() const
{
	return execution_time;
}
