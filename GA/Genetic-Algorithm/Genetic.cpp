#include "Genetic.h"
#include <algorithm>
#include <iostream>
#include <numeric>
#include <random>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include "Crossover.h"
#include "Item.h"
#include "Mutation.h"
#include <cmath>
#include "Chromosome.h"
#include "HillClimbing.h"
#include "RectanglePlacement.h"
#include "Utility.h"


// TODO: - important
// selection from mutations based on no-improvement (more infeasible)
// and ratio (feasible/pop size) during generations
// using feasible insert for repairing
// add excel
// plot for unoccupied calculation

using namespace std;
using namespace RectanglePlacement;

Genetic::Genetic(vector<Item> items, int z, double epsilon, int pop_size, double init_infeasibility,
	double mutation_probability,
	double crossover_probability,
	double convergence_threshold,
	double elite_percentage, int tournament_size, int max_generation,
	int time_limit, int no_improvement_threshold, int eval_limit,
	SurvivalType survivalType,
	StopType stop_type,
	int bin_width, int bin_height
	, bool memetic, int best_num_bin) : best_solution_(Chromosome(items))
{
	this->best_num_bin = best_num_bin;
	Chromosome::set_constant(z, epsilon);
	this->epsilon = epsilon;
	this->stop_type = stop_type;
	this->no_improvement_threshold = no_improvement_threshold;
	this->eval_limit = eval_limit;
	this->init_infeasibility_ = init_infeasibility;
	this->current_generation_ = 0;
	this->survivalType = survivalType;
	this->max_generation_ = max_generation;
	this->tournament_size_ = tournament_size;
	this->elite_percentage_ = elite_percentage;
	this->bin_width_ = bin_width;
	this->bin_height_ = bin_height;
	this->population_size_ = pop_size;
	this->z = z;
	this->items_ = move(items);
	this->item_size_ = static_cast<int>(this->items_.size());
	this->crossover_probability_ = crossover_probability;
	this->mutation_probability_ = mutation_probability;
	this->min_bins = calculate_min_bins();
	this->loop_duration = chrono::seconds(time_limit);
	this->time_limit = time_limit;
	this->convergence_threshold_ = convergence_threshold;
	this->temp_epsilon = epsilon;
	this->memetic = memetic;
}

double Genetic::calculate_repair_probability(std::chrono::high_resolution_clock::time_point start, int count) const
{
	if (stop_type == generation)
	{
		double generation_factor = (-current_generation_ * 2) / static_cast<double>(max_generation_);

		return (1 - exp(generation_factor));
	}
	if (stop_type == timeLimit)
	{
		auto time_passed_long = std::chrono::duration_cast<std::chrono::seconds>(
			(chrono::high_resolution_clock::now() - start)).count();
		int time_passed = static_cast<int>(time_passed_long);
		double time_factor = (-(time_passed * 3) / static_cast<double>(time_limit));
		return (1 - exp(time_factor));
	}
	if (stop_type == convergence)
	{
		double improve_factor = (-count * 2) / static_cast<double>(no_improvement_threshold);
		return (1 - exp(improve_factor));
	}
	double generation_factor = (-current_generation_ * 2) / static_cast<double>(max_generation_);
	return (1 - exp(generation_factor));

	//return (1 - exp(generation_factor)) * (static_cast<double>(infeasible_count) / population_size_);
}

double Genetic::calculate_penalty_factor(std::chrono::high_resolution_clock::time_point start, int count) const
{
	if (stop_type == generation)
	{
		return (2 * current_generation_ + max_generation_) / static_cast<double>(max_generation_);
	}
	if (stop_type == timeLimit)
	{
		auto time_passed_long = std::chrono::duration_cast<std::chrono::seconds>(
			(chrono::high_resolution_clock::now() - start)).count();
		int time_passed = static_cast<int>(time_passed_long);
		return (2 * time_passed + time_limit) / (static_cast<double>(time_limit));
	}
	if (stop_type == convergence)
	{
		return (no_improvement_threshold + 2 * count) / static_cast<double>(no_improvement_threshold);
	}
	return (2 * current_generation_ + max_generation_) / static_cast<double>(max_generation_);
}

// there is a bug here, worse bin number is accepted (perhaps for penalty factor)
void Genetic::local_search(chrono::steady_clock::time_point start, int no_improvement_count, int& infeasible_count,
	int& feasible_count, vector<Chromosome>& new_population, double& min_value)
{
	random_device rd;
	mt19937 gen(rd());
	uniform_real_distribution<double> dis(0.0, 1.0);
	double penalty_factor = calculate_penalty_factor(start, no_improvement_count);
	for (Chromosome& chromosome : new_population)
	{
		if (chromosome.get_feasibility())
		{
			if (dis(gen) < 0.25) continue;

			HillClimbing hc(chromosome, 10, 5, 5, penalty_factor);
			hc.algorithm();
			chromosome = hc.getBest_solution();
			chromosome.update_frontiers();
			if (chromosome.get_feasibility() && (chromosome.get_fitness() < best_solution_.get_fitness() || best_solution_.get_num_bins() > chromosome.get_num_bins()))
			{
				min_value = chromosome.get_fitness();
				best_solution_ = chromosome;
				auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start)).count();
				this->execution_time = static_cast<int>(stop);
				/*cout << "Local current bins: " << chromosome.get_groups().size() << '\n';
				cout << "---------------- Local " << current_generation_ << "  ---------------" << '\n';*/
			}
		}
	}
}

// fitness sharing , crowding
// for keeping diversity
void Genetic::algorithm()
{
	random_device rd;
	mt19937 gen(rd());
	uniform_real_distribution<> dis(0.0, 1.0);
	mating_pool_ = initialize_population();
	int sum_bins = 0;
	double sum_objective = 0.0;
	for (Chromosome offspring : mating_pool_)
	{
		sum_bins += static_cast<int>(offspring.get_groups().size());
		sum_objective += offspring.get_fitness();
	}
	double avg_obj = sum_objective / static_cast<double>(population_size_);
	cout << "Avg starting bin: " << ceil(sum_bins / static_cast<double>(population_size_)) << '\n';
	cout << "Avg starting objectives: " << avg_obj << '\n';
	ranges::shuffle(mating_pool_, gen);
	best_solution_ = mating_pool_[0];
	best_solution_.set_objective(10);
	cout << "min_bins: " << min_bins << '\n';
	bool stopped = false;
	vector<double> probabilities(Mutation::tweak_numbers, 1 / static_cast<double>(Mutation::tweak_numbers));
	tweak_probabilities.push_back(probabilities);
	auto start = chrono::high_resolution_clock::now();
	int no_improvement_count = 0;
	while (!stopped)
	{
		//cout << current_generation_ << '\n';
		vector<int> nReward(Mutation::tweak_numbers, 0);
		vector<int> nPenalty(Mutation::tweak_numbers, 0);
		int infeasible_count = 0;
		int feasible_count = 0;
		ranges::shuffle(mating_pool_, gen);
		vector<Chromosome> old_population(mating_pool_);
		vector<Chromosome> new_population;
		double min_value = best_solution_.get_fitness();
		while (new_population.size() < population_size_)
		{
			Parents parents = parent_selection();
			double crossover_prob = dis(gen);
			vector<Chromosome> offsprings;
			if (crossover_prob < crossover_probability_)
			{
				offsprings = Crossover::swap_two_point(parents.parent1, parents.parent2);
			}
			else
				offsprings = { parents.parent1, parents.parent2 };

			double penalty_factor = calculate_penalty_factor(start, no_improvement_count);

			for (Chromosome& offspring : offsprings)
			{
				offspring.check_feasibility();

				bool repaired = repair_chromosome(offspring, start, no_improvement_count);

				offspring.calculate_fitness(penalty_factor);
				eval_count_++;
				double mutation_prob = dis(gen);
				FunctionID selectedFunctionID = Feasible_Reinsert;
				if (mutation_prob < mutation_probability_)
				{
					double old_objective = offspring.get_fitness();
					selectedFunctionID = Mutation::select_tweak(probabilities);
					offspring = Mutation::apply_mutation(selectedFunctionID, offspring);
					offspring.check_feasibility();
					double new_objective = offspring.calculate_fitness(penalty_factor);
					eval_count_++;
					if (new_objective < old_objective)
					{
						nReward[selectedFunctionID]++;
					}
					else
					{
						nPenalty[selectedFunctionID]++;
					}
				}

				if (!offspring.get_feasibility())
				{
					infeasible_count++;
				}
				else
				{
					feasible_count++;
				}

				new_population.push_back(offspring);
				if (offspring.get_feasibility() && (best_solution_.get_fitness() > offspring.get_fitness() || best_solution_.get_num_bins() > offspring.get_num_bins()))
				{
					/*cout << "current bins: " << offspring.get_groups().size() << '\n';
					cout << "----------------  " << current_generation_ << "  ---------------" << '\n';*/
					best_solution_ = offspring;
					auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start)).count();
					this->execution_time = static_cast<int>(stop);
					min_value = best_solution_.get_fitness();
				}
			}
		}

		// memetic a function
		if (memetic)
			local_search(start, no_improvement_count, infeasible_count, feasible_count, new_population, min_value);
		number_infeasible.push_back(infeasible_count);
		number_feasible.push_back(feasible_count);
		best_objectives.push_back(best_solution_.get_fitness());
		// no improvement
		int best_size = static_cast<int>(best_objectives.size());
		if (best_size >= 2)
		{
			if (abs(best_objectives[best_size - 2] - best_objectives[best_size - 1]) < convergence_threshold_)
			{
				no_improvement_count++;

				//cout << "no improvement count: " << no_improvement_count << '\n';
			}
			else
			{
				no_improvement_count = 0;
			}
		}

		survival_selection(new_population, old_population);
		double sum = 0;
		for (const Chromosome& chromosome : mating_pool_) sum += chromosome.get_fitness();
		all_objectives.push_back(sum / static_cast<double>(population_size_));
		for (int i = 0; i < Mutation::tweak_numbers; i++)
		{
			Mutation::RD[i].push_back(nReward[i]);
			Mutation::PN[i].push_back(nPenalty[i]);
		}

		probabilities = Mutation::reassign_probabilities();
		tweak_probabilities.push_back(probabilities);
		current_generation_++;

		//display_population(new_population);
		stopped = stopping_condition(start, no_improvement_count);
	}
	//cout << "----------------  " << current_generation_ << "  ---------------" << '\n';
}

vector<Chromosome> Genetic::feasible_initialization(int feasible_pop_size)
{
	random_device rd;
	mt19937 gen(rd());
	vector<Chromosome> population;
	while (population.size() < feasible_pop_size)
	{
		Chromosome chromosome = feasible_random_packing(items_);
		auto start = chrono::high_resolution_clock::now();
		double penalty_factor = calculate_penalty_factor(start, 0);
		chromosome.calculate_fitness(penalty_factor);
		eval_count_++;
		population.push_back(chromosome);
	}
	return population;
}

vector<Chromosome> Genetic::infeasible_initialization(int infeasible_pop_size)
{
	random_device rd;
	mt19937 gen(rd());
	uniform_real_distribution<> real_dis(0, 1);
	vector<Chromosome> population;
	population.reserve(infeasible_pop_size);
	while (population.size() < infeasible_pop_size)
	{
		ranges::shuffle(items_, gen);
		double number = pow(real_dis(gen), 10) * (item_size_ - min_bins) + min_bins;
		int bins_count = static_cast<int>(round(number));
		vector<int> items_per_bin(bins_count, 1);
		int remaining_items = item_size_ - bins_count;
		int i = 0;
		while (remaining_items > 0 && i < bins_count)
		{
			double average_remaining_items = static_cast<double>(remaining_items) / (bins_count - i);
			normal_distribution<> normal_dis(average_remaining_items, average_remaining_items / 3);
			int add = static_cast<int>(round(normal_dis(gen)));
			add = max(1, min(add, remaining_items));
			items_per_bin[i++] += add;
			remaining_items -= add;
		}

		vector<Bin> bins;
		bins.reserve(bins_count);
		int currentItemIndex = 0;
		int id = 0;
		for (int i = 0; i < bins_count; ++i)
		{
			Bin new_bin(id++, bin_width_, bin_height_);
			for (int j = 0; j < items_per_bin[i]; ++j)
			{
				uniform_int_distribution<> width_int_dis(0, bin_width_ - items_[currentItemIndex].get_width());
				uniform_int_distribution<> height_int_dis(0, bin_height_ - items_[currentItemIndex].get_height());
				int x = width_int_dis(gen);
				int y = height_int_dis(gen);
				items_[currentItemIndex].set_xy(x, y);
				new_bin.add_item(items_[currentItemIndex++]);
			}
			bins.push_back(new_bin);
		}

		Chromosome chromosome(items_, bins);
		chromosome.check_feasibility();
		for (Bin& bin : chromosome.get_groups())
		{
			auto unoccupied_areas = detect_unoccupied_areas(bin.get_items(), bin.get_width(), bin.get_height());
			auto merged_spaces = merge_spaces(unoccupied_areas);
			int bin_area = calculate_total_area(merged_spaces);
			bin.set_unoccupied_area(bin_area);
		}
		auto start = chrono::high_resolution_clock::now();
		double penalty_factor = calculate_penalty_factor(start, 0);
		chromosome.calculate_fitness(penalty_factor);
		eval_count_++;
		population.push_back(chromosome);
	}
	return population;
}

// a portion of population can be added just random, but feasible
// we can generate n number of bin
// then placing one item per each bin
// then using insert feasible
// to place others items into the bins
vector<Chromosome> Genetic::initialize_population()
{
	vector<Chromosome> population;
	int feasible_count_pop = ceil(population_size_ * (1 - init_infeasibility_));
	vector<Chromosome> feasible_pop = feasible_initialization(feasible_count_pop);
	vector<Chromosome> infeasible_pop = infeasible_initialization(floor(population_size_ * init_infeasibility_));
	population.reserve(feasible_pop.size() + infeasible_pop.size());
	population.insert(population.end(), feasible_pop.begin(), feasible_pop.end());
	population.insert(population.end(), infeasible_pop.begin(), infeasible_pop.end());
	return population;
}

Chromosome Genetic::row_packing(vector<Item> items) const
{
	vector<Bin> bins;
	unordered_map<int, Item> items_map;
	vector<Item> leftover_items;
	vector<Item> placed_items;
	random_device rd;
	mt19937 gen(rd());
	for (const auto& item : items)
	{
		items_map[item.get_id()] = item;
	}

	int count = 0;
	while (!items_map.empty())
	{
		vector<Item> current_batch;
		if (items_map.empty())
		{
			current_batch = leftover_items;
			leftover_items.clear();
		}
		else
		{
			vector<int> keys;
			keys.reserve(items_map.size());
			int total_item_size = 0;
			for (const auto& pair : items_map)
			{
				keys.push_back(pair.first);
				total_item_size += pair.second.get_area();
			}
			for (const auto& pair : leftover_items)
			{
				total_item_size += pair.get_area();
				keys.push_back(pair.get_id());
			}
			leftover_items.clear();

			double average_item_size = total_item_size / static_cast<double>(keys.size());
			int remaining_capacity = bin_height_ * bin_width_; // Reset for each new bin
			int average_remaining_items = static_cast<int>(remaining_capacity / average_item_size);
			normal_distribution<> normal_dis(average_remaining_items, 1);
			int N = static_cast<int>(round(normal_dis(gen)));
			//uniform_int_distribution<> dis(0, min(10, static_cast<int>(items_map.size())));
			//N = dis(gen);
			N = max(1, min(N, static_cast<int>(keys.size())));
			if (N <= 0) continue;
			vector<int> selected_keys;
			ranges::sample(keys, back_inserter(selected_keys), N, gen);
			for (const auto& id : selected_keys)
			{
				current_batch.push_back(items_map[id]);
				items_map.erase(id);
			}
		}

		ranges::sort(current_batch, [](const Item& a, const Item& b)
			{
				if (a.get_height() != b.get_height())
				{
					return a.get_height() > b.get_height();
				}
				return a.get_width() < b.get_width();
			});

		Bin new_bin(static_cast<int>(bins.size()) + 1, bin_width_, bin_height_);
		//vector<Item> current_fits;
		bool item_fitted = false;
		for (auto& item : current_batch)
		{
			bool placed = new_bin.place_item_bin(item);

			if (!placed)
			{
				leftover_items.push_back(item);
			}
			else
			{
				new_bin.add_item(item);
				new_bin.set_unoccupied_area(new_bin.get_unoccupied_area() - item.get_area());
				//current_fits.push_back(item);
				item_fitted = true;
				placed_items.push_back(item);
			}
		}

		if (item_fitted)
		{
			new_bin.set_bin_feasibility(true);
			bins.push_back(new_bin);
		}

		for (const auto& item : leftover_items)
		{
			items_map[item.get_id()] = item;
		}
		leftover_items.clear();
	}

	if (placed_items.size() != items.size())
	{
		cerr << "Error: All items are not packed" << '\n';
		throw runtime_error("All items are not packed");
	}
	Chromosome chromosome(placed_items, bins);
	chromosome.set_feasible(true);
	return chromosome;
}

Chromosome Genetic::feasible_random_packing(vector<Item> items) const
{
	vector<Bin> bins;
	unordered_map<int, Item> items_map;
	vector<Item> leftover_items;
	vector<Item> placed_items;
	random_device rd;
	mt19937 gen(rd());
	ranges::shuffle(items, gen);
	for (const auto& item : items)
	{
		items_map[item.get_id()] = item;
	}
	int estimates_bins_size = min_bins;
	while (!items_map.empty())
	{
		vector<Item> current_batch;
		if (items_map.empty())
		{
			current_batch = leftover_items;
			leftover_items.clear();
		}
		else
		{
			vector<int> keys;
			keys.reserve(items_map.size());
			int total_remaining_item_area = 0;
			for (const auto& pair : items_map)
			{
				keys.push_back(pair.first);
				total_remaining_item_area += pair.second.get_area();
			}
			for (const auto& pair : leftover_items)
			{
				total_remaining_item_area += pair.get_area();
				keys.push_back(pair.get_id());
			}
			leftover_items.clear();

			double average_item_area = total_remaining_item_area / static_cast<double>(keys.size());
			// average item area per each item
			int remaining_capacity = bin_height_ * bin_width_;
			int avg_items_per_bin = static_cast<int>(remaining_capacity / average_item_area);
			normal_distribution<> normal_dis(avg_items_per_bin, 0.25);
			//cout << "avg item per bin: " << avg_items_per_bin << '\n';
			int N = static_cast<int>(round(normal_dis(gen)));
			/*uniform_int_distribution<> dis(0, min(10, static_cast<int>(items_map.size())));
			int N = dis(gen);*/
			N = max(1, min(N, static_cast<int>(keys.size())));
			if (N <= 0) continue;
			vector<int> selected_keys;
			ranges::sample(keys, back_inserter(selected_keys), N, gen);
			for (const auto& id : selected_keys)
			{
				current_batch.push_back(items_map[id]);
				items_map.erase(id);
			}
		}


		Bin new_bin(static_cast<int>(bins.size()) + 1, bin_width_, bin_height_);
		bool item_fitted = false;
		for (auto& item : current_batch)
		{
			bool placed = new_bin.place_item_feasible_randomly(item);
			if (!placed)
			{
				leftover_items.push_back(item);
			}
			else
			{
				new_bin.add_item(item);
				new_bin.set_unoccupied_area(new_bin.get_unoccupied_area() - item.get_area());
				item_fitted = true;
				placed_items.push_back(item);
			}
		}

		if (item_fitted)
		{
			new_bin.set_bin_feasibility(true);
			bins.push_back(new_bin);
		}

		for (const auto& item : leftover_items)
		{
			items_map[item.get_id()] = item;
		}
		leftover_items.clear();
	}

	if (placed_items.size() != items.size())
	{
		cerr << "Error: All items are not packed" << '\n';
		throw runtime_error("All items are not packed");
	}
	Chromosome chromosome(placed_items, bins);
	chromosome.set_feasible(true);
	return chromosome;
}


// last fit packing
Chromosome Genetic::feasible_LF_packing_v2(vector<Item> items) const
{
	std::vector<Bin> bins;
	Bin current_bin(1, bin_width_, bin_height_);
	current_bin.set_bin_feasibility(true);
	bins.push_back(current_bin);
	std::vector<Item> placed_items;
	random_device rd;
	mt19937 gen(rd());
	ranges::shuffle(items, gen);

	for (auto& item : items)
	{
		if (!bins.back().place_item_feasible_randomly(item))
		{
			/*bool item_fitted = false;

			for (Bin& bin : bins)
			{
				if (bin.get_unoccupied_area() <= item.get_area())
					continue;

				if (bins.back().get_id() != bin.get_id())
				{
					if (bin.place_item_feasible_randomly(item))
					{
						bin.add_item(item);
						item_fitted = true;
						placed_items.push_back(item);
						bin.set_unoccupied_area(bin.get_unoccupied_area() - item.get_area());
						break;
					}
				}
			}
			if (item_fitted)
			{
				continue;
			}*/
			Bin new_bin(bins.size() + 1, bin_width_, bin_height_);
			if (!new_bin.place_item_feasible_randomly(item))
			{
				throw std::runtime_error("Item cannot be placed in a new bin of specified size.");
			}
			new_bin.set_bin_feasibility(true);
			bins.push_back(new_bin);
		}
		bins.back().add_item(item);
		placed_items.push_back(item);
		bins.back().set_unoccupied_area(bins.back().get_unoccupied_area() - item.get_area());
	}

	if (placed_items.size() != items.size())
	{
		cerr << "Error: All items are not packed" << '\n';
		throw runtime_error("All items are not packed");
	}
	Chromosome chromosome(placed_items, bins);
	chromosome.set_feasible(true);
	return chromosome;
}

Chromosome Genetic::brute_force_packing(vector<Item> items) const
{
	ranges::sort(items, [](const Item& a, const Item& b)
		{
			if (a.get_height() != b.get_height())
			{
				return a.get_height() > b.get_height();
			}
			return a.get_width() > b.get_width();
		});
	vector<Bin> bins;
	int id = 0;
	int i = 0;

	while (i < items.size())
	{
		Bin new_bin(id, bin_width_, bin_height_);
		while (i < items.size() && new_bin.place_rectangle(items[i]))
		{
			i++;
		}
		bins.push_back(new_bin);
		id++;
	}
	return { items, bins };
}

vector<Chromosome> Genetic::select_candidates() const
{
	unordered_set<int> unique_numbers;
	vector<Chromosome> candidates;
	candidates.reserve(unique_numbers.size());
	random_device rd;
	mt19937 gen(rd());
	uniform_int_distribution<> distribute(0, population_size_ - 1);
	while (static_cast<int>(unique_numbers.size()) < 5)
	{
		unique_numbers.insert(distribute(gen));
	}
	for (int index : unique_numbers)
	{
		candidates.push_back(mating_pool_[index]);
	}
	return candidates;
}

Parents Genetic::parent_selection() const
{
	vector<Chromosome> candidates = select_candidates();
	ranges::sort(candidates, [](const Chromosome& a, const Chromosome& b)
		{
			return a.get_fitness() < b.get_fitness();
		});
	return { candidates[0], candidates[1] };
}

void Genetic::elitism_selection(vector<Chromosome> new_population, vector<Chromosome> old_population)
{
	ranges::sort(old_population, [](const Chromosome& a, const Chromosome& b)
		{
			if (a.get_feasibility() != b.get_feasibility())
			{
				return a.get_feasibility() > b.get_feasibility();
			}

			return a.get_fitness() < b.get_fitness();
		});
	//display_population(mating_pool_);
	int elite_size = static_cast<int>(old_population.size()) * elite_percentage_;
	vector<Chromosome> selected_population;
	for (size_t i = 0; i < elite_size; ++i)
	{
		selected_population.push_back(old_population[i]);
	}

	ranges::sort(new_population, [](const Chromosome& a, const Chromosome& b)
		{
			if (a.get_feasibility() != b.get_feasibility())
			{
				return a.get_feasibility() < b.get_feasibility();
			}
			return a.get_fitness() > b.get_fitness();
		});


	for (size_t i = 0; i < elite_size; ++i)
	{
		new_population[i] = selected_population[i];
	}
	mating_pool_ = new_population;
}

void Genetic::generational_selection(vector<Chromosome> new_population)
{
	mating_pool_ = move(new_population);
}

void Genetic::survival_selection(const vector<Chromosome>& new_population, const vector<Chromosome> old_population)
{
	switch (survivalType)
	{
	case 0:
		elitism_selection(new_population, old_population);
		break;
	case 1:
		generational_selection(new_population);
		break;
	}
}

Chromosome Genetic::get_best_solution()
{
	return best_solution_;
}

void Genetic::display_population(vector<Chromosome>& population)
{
	for (Chromosome& chromosome : population)
	{
		chromosome.display_chromosome();
	}
}

int Genetic::calculate_min_bins()
{
	int total_area = 0;
	for (Item& item : items_)
	{
		total_area += (item.get_height() * item.get_width());
	}
	int bin_area = bin_width_ * bin_height_;
	return ceil((total_area / static_cast<double>(bin_area)));
}

bool Genetic::stopping_condition(std::chrono::high_resolution_clock::time_point start, int count)
{
	if (best_solution_.get_num_bins() == best_num_bin)
		return true;

	switch (stop_type)
	{
	case timeLimit:
		return this->stop_by_time(start);
		break;
	case generation:
		return this->stop_by_generation(start);
		break;
	case convergence:
		return this->stop_by_convergence(count, start);
		break;
	case evalCount:
		return this->stop_by_eval_count(start);
		break;
	}
	return this->stop_by_generation(start);
}

bool Genetic::stop_by_eval_count(std::chrono::high_resolution_clock::time_point start)
{
	if (eval_count_ < eval_limit) return false;
	/*auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start)).
		count();
	this->execution_time = static_cast<int>(stop);*/
	return true;
}

bool Genetic::stop_by_convergence(const int count, std::chrono::high_resolution_clock::time_point start)
{
	if (count >= no_improvement_threshold)
	{
		/*auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start)).
			count();
		this->execution_time = static_cast<int>(stop);*/
		return true;
	}

	if (current_generation_ >= max_generation_)
	{
		//auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start)).
		//	count();
		//this->execution_time = static_cast<int>(stop);
		return true;
	}

	return false;
}

bool Genetic::stop_by_generation(std::chrono::high_resolution_clock::time_point start)
{
	if (current_generation_ < max_generation_) return false;
	//auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start)).
	//	count();
	////cout << "exit time: " << stop << '\n';
	//this->execution_time = static_cast<int>(stop);
	return true;
}

bool Genetic::stop_by_time(std::chrono::high_resolution_clock::time_point start)
{
	if (chrono::high_resolution_clock::now() - start < loop_duration)
		return false;
	//auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start)).
	//	count();
	//this->execution_time = static_cast<int>(stop);
	return true;
}

bool Genetic::repair_chromosome(Chromosome& chromosome, std::chrono::high_resolution_clock::time_point start,
	int no_improvement_count) const
{
	if (!chromosome.get_feasibility())
	{
		random_device rd;
		mt19937 gen(rd());
		uniform_real_distribution<> dis(0.0, 1.0);
		double repair_possibility = dis(gen);
		double prob = calculate_repair_probability(start, no_improvement_count);
		prob = 0.3;
		if (repair_possibility < prob)
		{
			chromosome = repair_chromosome_random(chromosome);
			chromosome.set_feasible(true);
			return true;
		}
	}
	return false;
}

Chromosome Genetic::repair_chromosome_semi_heuristic(Chromosome& offspring) const
{
	vector<Bin> new_groups;
	vector<Item> leftover_items;
	vector<Item> placed_items;
	for (Bin& bin : offspring.get_groups())
	{
		unordered_map<int, Item>& bin_items = bin.get_items();
		vector<Item> items;
		items.reserve(bin_items.size());
		for (auto& [id, item] : bin_items)
		{
			items.push_back(item);
		}

		items.insert(items.end(), leftover_items.begin(), leftover_items.end());
		leftover_items.clear();
		ranges::sort(items, [](const Item& a, const Item& b)
			{
				if (a.get_height() != b.get_height())
				{
					return a.get_height() > b.get_height();
				}
				return a.get_width() > b.get_width();
			});

		Bin new_bin(static_cast<int>(new_groups.size()), bin_width_, bin_height_);
		bool item_fitted = false;
		for (Item& item : items)
		{
			if (!new_bin.place_item_bin(item))
			{
				leftover_items.push_back(item);
			}
			else
			{
				new_bin.add_item(item);
				new_bin.set_unoccupied_area(new_bin.get_unoccupied_area() - item.get_area());
				item_fitted = true;
				placed_items.push_back(item);
			}
		}
		if (item_fitted)
		{
			new_bin.set_bin_feasibility(true);
			new_groups.push_back(new_bin);
		}
	}


	while (!leftover_items.empty())
	{
		Bin new_bin(static_cast<int>(new_groups.size()), bin_width_, bin_height_);
		bool item_fitted = false;
		vector<Item> temp_leftover;

		ranges::sort(leftover_items, [](const Item& a, const Item& b)
			{
				if (a.get_height() != b.get_height())
				{
					return a.get_height() > b.get_height();
				}
				return a.get_width() > b.get_width();
			});

		for (Item& item : leftover_items)
		{
			if (!new_bin.place_item_bin(item))
			{
				temp_leftover.push_back(item);
			}
			else
			{
				new_bin.add_item(item);
				new_bin.set_unoccupied_area(new_bin.get_unoccupied_area() - item.get_area());
				item_fitted = true;
				placed_items.push_back(item);
			}
		}

		leftover_items = temp_leftover;
		if (item_fitted)
		{
			new_bin.set_bin_feasibility(true);
			new_groups.push_back(new_bin);
		}
	}
	if (placed_items.size() != offspring.get_values().size())
	{
		cerr << "Error: All items are not packed" << '\n';
		throw runtime_error("All items are not packed");
	}

	Chromosome chromosome(placed_items, new_groups);
	chromosome.set_feasible(true);
	return chromosome;
}

Chromosome Genetic::repair_chromosome_random(Chromosome& offspring) const
{
	vector<Bin> new_groups;
	vector<Item> placed_items; // Items that are successfully placed
	unordered_set<int> placed_item_ids; // Track item IDs to avoid duplicates
	vector<Item> leftover_items; // Items that failed to be placed in the current bin

	for (Bin& bin : offspring.get_groups())
	{
		if (bin.get_bin_feasibility())
		{
			bin.set_unoccupied_area(bin_height_ * bin_width_);
			bin.set_id(static_cast<int>(new_groups.size()));
			new_groups.push_back(bin);
			for (auto& [id, item] : bin.get_items())
			{
				bin.set_unoccupied_area(bin.get_unoccupied_area() - item.get_area());
				if (placed_item_ids.insert(id).second)
				{
					placed_items.push_back(item);
				}
			}
			continue;
		}

		unordered_map<int, Item>& bin_items = bin.get_items();
		vector<Item> items;

		for (auto& [id, item] : bin_items)
		{
			if (!placed_item_ids.contains(id))
			{
				items.push_back(item);
			}
		}


		// Attempt to place items in a new bin
		Bin new_bin(static_cast<int>(new_groups.size()), bin_width_, bin_height_);
		for (Item& item : items)
		{
			if (new_bin.place_item_feasible_randomly(item))
			{
				new_bin.add_item(item);
				placed_item_ids.insert(item.get_id());
				placed_items.push_back(item);
				new_bin.set_unoccupied_area(new_bin.get_unoccupied_area() - item.get_area());
			}
			else
			{
				leftover_items.push_back(item);
			}
		}

		// If any items were placed, the bin is feasible
		if (!new_bin.get_items().empty())
		{
			new_bin.set_bin_feasibility(true);
			new_groups.push_back(new_bin);
		}
	}

	// Attempt to place leftover items in new bins until none can be placed
	while (!leftover_items.empty())
	{
		vector<Item> new_leftovers;
		Bin new_bin(static_cast<int>(new_groups.size()), bin_width_, bin_height_);

		for (Item& item : leftover_items)
		{
			if (new_bin.place_item_feasible_randomly(item))
			{
				new_bin.add_item(item);
				placed_item_ids.insert(item.get_id());
				placed_items.push_back(item);
				new_bin.set_unoccupied_area(new_bin.get_unoccupied_area() - item.get_area());
			}
			else
			{
				new_leftovers.push_back(item);
			}
		}

		if (!new_bin.get_items().empty())
		{
			new_bin.set_bin_feasibility(true);
			new_groups.push_back(new_bin);
		}

		leftover_items.swap(new_leftovers); // Update leftover items for the next iteration
	}

	// Final check to ensure all items have been placed
	if (placed_items.size() != offspring.get_values().size())
	{
		cerr << "Error: All items are not packed" << '\n';
		throw runtime_error("All items are not packed");
	}

	Chromosome chromosome(placed_items, new_groups);
	chromosome.set_feasible(true);
	return chromosome;
}
