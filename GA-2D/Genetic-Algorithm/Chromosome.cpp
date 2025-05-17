#include "Chromosome.h"

#include <algorithm>
#include <iostream>
#include <map>
#include <set>
#include <utility>
#include "Bin.h"

using namespace std;
int Chromosome::z = 0;
double Chromosome::eta = 10.0;
void Chromosome::set_constant(int z_value, double eta_value) {
	z = z_value;
	eta = eta_value;
}

Chromosome::Chromosome(vector<Item> values)
{
	this->feasible = false;
	this->fitness_ = 0.0;
	this->items_ = move(values);
	this->item_size_ = static_cast<int>(values.size());
}

Chromosome::Chromosome(vector<Item> items, vector<Bin> groups)
{
	this->item_size_ = static_cast<int>(items.size());
	this->items_ = move(items);
	this->groups_ = move(groups);
	update_frontiers();
	this->feasible = check_feasibility();
}


bool Chromosome::check_feasibility()
{
	update_frontiers();
	feasible = true;
	if (!check_feasibility_permutation())
	{
		feasible = false;
		//cout << " bad permutation" << '\n';
		return feasible;
	}

	for (Bin& bin : groups_)
	{
		if (!bin.check_bin_feasibility())
		{
			bin.set_bin_feasibility(false);
			feasible = false;
		}
		else
		{
			bin.set_bin_feasibility(true);

		}

	}
	return feasible;
}


bool Chromosome::check_feasibility_permutation() const
{
	bool feasibility = true;
	set<int> item_ids;
	for (const Item& item : items_)
	{
		item_ids.insert(item.get_id());
	}
	if (item_ids.size() != item_size_) feasibility = false;
	if (!check_item_bin_consistency()) feasibility = false;
	return feasibility;
}

bool Chromosome::check_item_bin_consistency() const
{
	map<int, Bin> bin_map;
	for (const Bin& bin : groups_)
	{
		bin_map[bin.get_id()] = bin;
	}

	for (const Item& item : items_)
	{
		int bin_id = item.get_bin_id();
		auto it = bin_map.find(bin_id);
		if (it == bin_map.end())
		{
			cout << "item " << item.get_id() << " bad bin Id: " << bin_id << '\n';
			return false;
		}

		const Bin& bin = it->second;
		if (!bin.contains(item))
		{
			cout << "Item ID " << item.get_id() << " not found in bin ID " << bin_id << '\n';
			return false;
		}
	}

	return true;
}

void Chromosome::remove_bin(const Bin& bin_to_remove)
{
	int remove_id = bin_to_remove.get_id();
	erase_if(groups_,
		[remove_id](const Bin& bin) { return bin.get_id() == remove_id; });
}

void Chromosome::update_frontiers()
{
	frontiers_.clear();
	items_.clear();

	if (groups_.empty()) return;

	int current_index = 0;

	for (auto& group : groups_)
	{
		auto bin_items = group.get_items();

		for (auto& [id, item_pair] : bin_items)
		{
			item_pair.set_bin_id(group.get_id());
			items_.push_back(item_pair);
			++current_index;
		}

		if (!bin_items.empty())
		{
			frontiers_.push_back(current_index - 1);
		}
	}
}

void Chromosome::display_chromosome()
{
	for (Bin& group : groups_)
	{
		cout << '\n';
		cout << "Bin " << group.get_id() << ": ";
		for (const auto& [id, item] : group.get_items())
		{
			item.display_item();
			cout << ", ";
		}
	}

	cout << '\n' << boolalpha << "feasible: " << feasible << ", " << "objective: " << fitness_ << '\n';
}

void Chromosome::display_chromosome_items() const
{
	for (const Item& item : items_)
	{
		cout << item.get_id() << ", ";
	}
	cout << ": " << fitness_ << '\n';
}

vector<Item>& Chromosome::get_values()
{
	return items_;
}

void Chromosome::set_values(const vector<Item>& new_values)
{
	this->items_ = new_values;
}

vector<Bin> Chromosome::get_bin_version()
{
	return groups_;
}

void Chromosome::set_groups(const vector<Bin>& groups)
{
	this->groups_ = groups;
	update_frontiers();
}

void Chromosome::set_objective(double objective)
{
	this->fitness_ = objective;
}

vector<Bin>& Chromosome::get_groups()
{
	return groups_;
}

vector<int> Chromosome::get_frontiers()
{
	return frontiers_;
}

void Chromosome::set_feasible(const bool feasibility)
{
	this->feasible = feasibility;
	if (feasibility)
	{
		for (Bin& bin : groups_)
		{
			bin.set_bin_feasibility(true);
		}
	}
}

double Chromosome::get_fitness() const
{
	return fitness_;
}

void Chromosome::set_frontiers(const vector<int>& frontiers)
{
	this->frontiers_ = frontiers;
}

bool Chromosome::get_feasibility() const
{
	return feasible;
}

double Chromosome::calculate_fitness(double penalty_factor)
{
	objective = objective_function();
	penalty = calculate_penalty();

	constexpr double alpha = 1.0;
	constexpr double beta = 1.5;

	fitness_ = alpha * objective + beta * penalty_factor * penalty;
	return fitness_;
}

double Chromosome::objective_function() const
{
	double total_utilization = 0;
	int count_feasible_bins = 0;

	for (const auto& bin : groups_)
	{
		if (!bin.get_bin_feasibility()) {
			continue;
		}
		count_feasible_bins++;
		double utilization_ratio = (bin.get_total_area() - bin.get_free_area());
		total_utilization += utilization_ratio;
	}

	total_utilization /= static_cast<double>(groups_.size() * groups_[0].get_total_area());
	total_utilization = pow(total_utilization, z);
	if (count_feasible_bins > 0) {
		return 1 - (total_utilization);
	}
	return 1;
}

double Chromosome::calculate_bin_penalty(const Bin& bin)
{
	double bin_capacity = bin.get_total_area();
	double items_total_area = bin.get_used_area();
	double unoccupied_space = bin.get_unoccupied_area();
	double occupied_area = bin_capacity - unoccupied_space;
	double overlap_area = items_total_area - occupied_area;
	double overlap_penalty = (overlap_area > 0) ? (overlap_area / bin_capacity) : 0.0;
	double unoccupied_penalty = (unoccupied_space / bin_capacity);
	return  overlap_penalty;
	//return 0.8 * overlap_penalty + 0.2 * unoccupied_penalty;
}

double Chromosome::calculate_penalty() const {
	if (get_feasibility()) return 0;
	double total_penalty = 0.0;
	int number_infeasible = 0;
	for (const Bin& bin : groups_) {
		if (!bin.get_bin_feasibility()) {
			total_penalty += calculate_bin_penalty(bin);
			number_infeasible++;
		}
	}

	// number of bins or infeasible binS?
	return total_penalty / static_cast<double>(number_infeasible);
}


int Chromosome:: get_num_bins() const {
	return groups_.size();
}

//// if number of bins is less than required number of bin set the objective 1
//double Chromosome::objective_function() const
//{
//	double ratio = 0;
//	for (const auto& bin : groups_)
//	{
//		if (!bin.get_bin_feasibility())
//		{
//
//			return 1.0;
//		}
//		const double a = ((bin.get_total_area() - bin.get_free_area()) / static_cast<double>(bin.get_total_area()));
//		ratio += pow(a, z);
//	}
//	ratio /= static_cast<double>(groups_.size());
//	return 1 - ratio;
//}



//double Chromosome::calculate_penalty() const
//{
//	if (get_feasibility()) return 0;
//	//A higher eta makes the fitness function more sensitive to infeasibility
//	int num_infeasible_bins = 0;
//	for (const Bin& bin : groups_) if (!bin.get_bin_feasibility()) num_infeasible_bins++;
//	double normalized_infeasibility = static_cast<double>(num_infeasible_bins) / static_cast<int>(groups_.size());
//	double penalty = 1 - exp(-eta * normalized_infeasibility);
//	return penalty;
//}
