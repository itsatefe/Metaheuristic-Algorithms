#include "HillClimbing.h"
#include <chrono>
#include <iostream>

#include "Chromosome.h"
#include "Genetic.h"
#include "Neighborhood.h"

using namespace std;


HillClimbing::HillClimbing(const Chromosome& offspring, int max_iteration, int no_improvement_threshold,
	int tweaks_count, double penalty_factor) : best_solution(offspring), first_solution(offspring)
{
	this->penalty_factor = penalty_factor;
	this->eval_Count = 0;
	this->no_improvement_count = 0;
	this->execution_time = 0;
	this->current_iteration = 1;
	this->max_iteration = max_iteration;
	this->no_improvement_threshold = no_improvement_threshold;
	this->tweaks_count = tweaks_count;
	//this->loop_duration = chrono::seconds(time_limit);
	//this->convergence_threshold = calculate_convergence_threshold(static_cast<int>(first_solution.get_values().size()));
	this->convergence_threshold = 0.005;
}


double HillClimbing::calculate_penalty_factor(int count) const
{
	return (no_improvement_threshold + 2 * count) / static_cast<double>(no_improvement_threshold);
	//return (2 * current_generation_ + max_generation_) / static_cast<double>(max_generation_);
}



bool HillClimbing::stopping_condition(int count) const
{

	if (current_iteration >= max_iteration)
		return true;
	return false;

}

bool HillClimbing::stopBy_Convergence(int count) const
{
	if (no_improvement_count >= no_improvement_threshold)
		return true;

	if (current_iteration >= max_iteration)
		return true;

	return false;
}


void HillClimbing::algorithm()
{
	double current_objective = first_solution.get_fitness();
	Chromosome current_binPacking = first_solution;
	double next_objective = first_solution.get_fitness();
	vector<double> probabilities(Neighborhood::tweak_numbers, 1 / static_cast<double>(Neighborhood::tweak_numbers));
	tweak_probabilities.push_back(probabilities);
	bool stopped = false;
	auto start = chrono::high_resolution_clock::now();
	while (!stopped)
	{
		vector<int> nReward(Neighborhood::tweak_numbers, 0);
		vector<int> nPenalty(Neighborhood::tweak_numbers, 0);
		for (int i = 0; i < tweaks_count; i++)
		{
			FunctionID selectedFunctionID = Neighborhood::select_tweak(probabilities);
			Chromosome next_binPacking = Neighborhood::apply_tweak(selectedFunctionID, current_binPacking);
			//double penalty_factor = calculate_penalty_factor(no_improvement_count);
			next_objective = next_binPacking.calculate_fitness(penalty_factor);
			eval_Count++;
			if (next_objective < current_objective)
			{
				//cout << "Improvement: " << next_binPacking.get_fitness() << '\n';
				nReward[selectedFunctionID] += 1;
				no_improvement_count = 0;
				objectives.push_back(next_objective);
				current_objective = next_objective;
				current_binPacking = next_binPacking;
			}
			else {
				no_improvement_count++;
				nPenalty[selectedFunctionID] += 1;
			}
		}

		if (current_objective < best_solution.get_fitness())
		{
			best_solution = current_binPacking;
		}
		for (int i = 0; i < Neighborhood::tweak_numbers; i++)
		{
			Neighborhood::RD[i].push_back(nReward[i]);
			Neighborhood::PN[i].push_back(nPenalty[i]);
		}

		probabilities = Neighborhood::reassign_probabilities();
		tweak_probabilities.push_back(probabilities);
		current_iteration++;
		stopped = stopping_condition(no_improvement_count);
		//cout << "- no improvement counter: " << count << '\n';
	}
	//cout << "- execution time: " << execution_time << '\n';
}

Chromosome HillClimbing::getBest_solution()
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

//double HillClimbing::calculate_convergence_threshold(int numItems)
//{
//	if (numItems <= 150)
//	{
//		return 0.0002;
//	}
//	if (numItems <= 500)
//	{
//		return 0.00005;
//	}
//	return 0.00001;
//}


//bool HillClimbing::stopping_condition(std::chrono::high_resolution_clock::time_point start, int count) const
//{
//	switch (stopType)
//	{
//	case timeLimit:
//		return this->stopBy_time(start);
//		break;
//	case iteration:
//		return this->stopBy_iteration();
//		break;
//	case convergence:
//		return this->stopBy_Convergence(count, start);
//		break;
//	default:
//		return false;
//	}
//}

//
//bool HillClimbing::stopBy_Convergence(int count, std::chrono::high_resolution_clock::time_point start) const
//{
//	if (count >= 25)
//	{
//		//cout << count << ": count" << '\n';
//		auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start)).
//			count();
//		//cout << "exit time: " << stop << '\n';
//		//this->execution_time = static_cast<int>(stop);
//		return true;
//	}
//
//	if (current_iteration >= max_iteration)
//	{
//		auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start)).
//			count();
//		//cout << "exit time: " << stop << '\n';
//		//this->execution_time = static_cast<int>(stop);
//		return true;
//	}
//
//	return false;
//}
//


//bool HillClimbing::stopBy_time(std::chrono::high_resolution_clock::time_point start) const
//{
//	if (chrono::high_resolution_clock::now() - start < loop_duration)
//		return false;
//	auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start));
//	/*cout << "exit time: " << stop << '\n';
//	cout << "last iteration: " << current_iteration << '\n';*/
//	return true;
//}
