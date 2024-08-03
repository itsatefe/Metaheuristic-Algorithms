#include "SimulatedAnnealing.h"
#include "BinPacking.h"
#include <vector>
#include "Types.h"
#include <functional>
#include <iostream>
#include "Neighborhood.h"
#include <random>
#include <chrono>
#include <thread>

using namespace std;

SimulatedAnnealing::SimulatedAnnealing(BinPacking& binPacking, ScheduleType schedule,
	int no_improvement_threshold, double temperature_threshold,
	double acceptance_rate,
	StopType stopType, double convergence_threshold,
	int no_overall_improvement_threshold, int time_limit) :
	binPacking(binPacking), best_solution(binPacking)
{
	this->current_iteration = 1;
	this->schedule = schedule;
	this->no_improvement_threshold = no_improvement_threshold;
	this->no_improvement_count = 0;
	this->reheating_count = 1;
	this->cooling_factor = 0.3;
	this->temperature_threshold = temperature_threshold;
	this->loop_duration = chrono::seconds(time_limit);
	this->acceptance_rate = acceptance_rate;
	this->initial_temp = calculate_initial_temp();
	//this->initial_temp = 100;
	this->temperature_old = initial_temp / cooling_factor;
	this->stopType = stopType;
	this->convergence_threshold = calculate_convergence_threshold(binPacking.getItems_size());
	this->no_overall_improvement_count = 0;
	this->no_overall_improvement_threshold = no_overall_improvement_threshold;
	//this->no_overall_improvement_threshold = binPacking.getMax_iteration() / no_improvement_threshold;
	this->eval_Count = 0;
	this->execution_time = 0;
}

double SimulatedAnnealing::calculate_convergence_threshold(int numItems)
{
	if (numItems <= 150)
	{
		return 0.005;
	}
	if (numItems <= 500)
	{
		return 0.001;
	}
	return 0.00005;
}

double SimulatedAnnealing::calculate_max_energy() const
{
	int items_size = binPacking.getItems_size();
	int bins_capacity = binPacking.getBins_capacity();
	BinPacking worst_binPacking(binPacking);
	auto items = worst_binPacking.getItems();
	unordered_map<int, Bin> bins;
	for (int i = 0; i < items_size; i++)
	{
		Bin bin(i, bins_capacity);
		bin.addToBin(items[i + 1]);
		items[i].setBin_id(i);
		items[i].setIs_used(true);
		bins[i] = bin;
	}
	worst_binPacking.set_bins(bins);
	worst_binPacking.set_items(items);
	// assume last solution was the best, with 0 as objective
	return worst_binPacking.objective_function();
}

double SimulatedAnnealing::calculate_initial_temp() const
{
	// c_max / lg acceptance, Metro police condition
	double c_max = calculate_max_energy();
	return -c_max / log(acceptance_rate);
}

double SimulatedAnnealing::calculate_temperatures(int k)
{
	switch (schedule)
	{
	case linear:
		return this->linear_cooling(k);
		break;
	case logarithmic:
		return this->logarithmic_cooling(k);
		break;
	case composite:
		return this->adaptive_cooling(k);
		break;
	case square_root:
		return this->square_root_cooling(k);
	default:
		return 0;
	}
}

double SimulatedAnnealing::logarithmic_cooling(int k) const
{
	return this->initial_temp / log(k + 1);
}

double SimulatedAnnealing::linear_cooling(int k) const
{
	return this->initial_temp / static_cast<double>(k + 1);
}

//double SimulatedAnnealing::linear_cooling(int k)
//{
//	double temp = initial_temp - k ;
//	if (temp <= 0.0) return 0.0001;
//	return temp;
//}

double SimulatedAnnealing::square_root_cooling(int k) const
{
	return this->initial_temp / sqrt(k + 1);
}


double SimulatedAnnealing::adaptive_cooling(int k)
{
	if (no_improvement_count >= no_improvement_threshold)
	{
		reheating_count++;
		temperature_old = initial_temp / static_cast<double>(min(reheating_count, 5));
		return temperature_old;
	}
	return cooling_factor * temperature_old;
}

bool SimulatedAnnealing::stopping_condition(std::chrono::high_resolution_clock::time_point start) const
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
		return this->stopBy_Convergence();
		break;
	default:
		return false;
	}
}

bool SimulatedAnnealing::stopBy_Convergence() const
{
	//cout << "no_overall_improvement_count: " << no_overall_improvement_count << '\n';
	if (no_overall_improvement_count >= no_overall_improvement_threshold) return true;

	if (const int max_iteration = binPacking.getMax_iteration(); current_iteration >= max_iteration) return true;

	return false;
}

bool SimulatedAnnealing::stopBy_iteration() const
{
	if (current_iteration >= binPacking.getMax_iteration()) return true;
	return false;
}

bool SimulatedAnnealing::stopBy_time(std::chrono::high_resolution_clock::time_point start) const
{
	if (chrono::high_resolution_clock::now() - start < loop_duration)
		return false;
	auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start));
	/*cout << "exit time: " << stop << '\n';
	cout << "last iteration: " << current_iteration << '\n';*/
	// if we does not have it returns true
	return true;
}

bool SimulatedAnnealing::equilibrium_condition(std::chrono::high_resolution_clock::time_point start)
{
	bool equil = true;
	if (stopType == 0)
	{
		if (stopBy_time(start))
		{
			equil = false;
		}
	}
	else
	{
		const int max_iteration = binPacking.getMax_iteration();
		if (current_iteration >= max_iteration)
		{
			equil = false;
		}
	}
	if (no_improvement_count >= no_improvement_threshold)
	{
		no_improvement_count = 0;
		no_overall_improvement_count++;
		equil = false;
	}
	else {
		no_overall_improvement_count = 0;
	}
	return equil;

}

bool move_next(uniform_real_distribution<>& dis, mt19937& gen, double difference, double T)
{
	double randomProbability = dis(gen);
	double threshold = exp(-difference / T);
	return randomProbability < threshold;
}

vector<double> SimulatedAnnealing::get_objectives()
{
	return objectives;
}

vector<double> SimulatedAnnealing::get_differences()
{
	return differences;
}

vector<vector<double>> SimulatedAnnealing::getTweak_probabilities()
{
	return tweak_probabilities;
}

int SimulatedAnnealing::get_execution_time()
{
	return execution_time;
}

BinPacking SimulatedAnnealing::getBest_solution()
{
	return best_solution;
}

vector<double> SimulatedAnnealing::get_temperatures()
{
	return temperatures;
}

void SimulatedAnnealing::algorithm()
{
	BinPacking current_binPacking = binPacking;
	random_device rd;
	mt19937 gen(rd());
	uniform_real_distribution<> dis(0, 1);
	vector<double> probabilities(neighborhood.tweak_numbers, 1 / static_cast<double>(neighborhood.tweak_numbers));
	neighborhood.setTweak_probabilities(probabilities);
	tweak_probabilities.push_back(probabilities);
	bool stopped = false;
	double current_T = 0.0;
	auto start = chrono::high_resolution_clock::now();
	int i = 1;
	while (!stopped)
	{
		current_T = calculate_temperatures(current_iteration);

		temperature_old = current_T;
		bool equil_cond = true;
		vector<int> nReward(neighborhood.tweak_numbers, 0);
		vector<int> nPenalty(neighborhood.tweak_numbers, 0);
		while (equil_cond)
		{
			temperatures.push_back(current_T);
			double current_objective = current_binPacking.objective_function();
			eval_Count++;
			objectives.push_back(current_objective);
			FunctionID selectedFunctionID = neighborhood.select_tweak();
			BinPacking next_binPacking = neighborhood.call_tweak(selectedFunctionID, current_binPacking).binPacking;
			double next_objective = next_binPacking.objective_function();
			double difference = next_objective - current_objective;
			differences.push_back(difference);
			if (difference < 0)
			{
				nReward[selectedFunctionID] += 1;
				if (next_objective < best_solution.objective_function())
				{
					auto stop = std::chrono::duration_cast<std::chrono::seconds>(
						(chrono::high_resolution_clock::now() - start)).
						count();
					this->execution_time = static_cast<int>(stop);
					best_solution = next_binPacking;
				}
				current_binPacking = next_binPacking;
			}
			else
			{
				nPenalty[selectedFunctionID] += 1;
				if (move_next(dis, gen, difference, current_T)) current_binPacking = next_binPacking;
			}
			if (abs(difference) <= convergence_threshold)
			{
				no_improvement_count++;
			}
			else
			{
				no_improvement_count = 0;
			}
			current_iteration++;
			equil_cond = equilibrium_condition(start);
		}
		for (int i = 0; i < neighborhood.tweak_numbers; i++)
		{
			neighborhood.RD[i].push_back(nReward[i]);
			neighborhood.PN[i].push_back(nPenalty[i]);
		}

		probabilities = neighborhood.reassign_probabilities();
		neighborhood.setTweak_probabilities(probabilities);
		stopped = stopping_condition(start);
		tweak_probabilities.push_back(probabilities);
	}
	//cout << "last iteration: " << current_iteration << '\n';
}
