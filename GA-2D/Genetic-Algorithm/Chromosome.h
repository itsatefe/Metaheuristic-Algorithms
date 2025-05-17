#ifndef CHROMOSOME_H
#define CHROMOSOME_H
#include <vector>
#include "Bin.h"
#include "Item.h"

using namespace  std;


class Chromosome {
public:
	static int z;
	static double eta;
	static void set_constant(int z_value, double eta_value);
	Chromosome(vector<Item> values);
	Chromosome(vector<Item> items, vector<Bin> groups);
	double get_fitness() const;
	void display_chromosome();
	void display_chromosome_items() const;
	vector<Item>& get_values();
	void set_values(const vector<Item>& new_values);
	vector<Bin> get_bin_version();
	void set_groups(const vector<Bin>& groups);
	void set_objective(double objective);
	vector<Bin>& get_groups();
	vector<int> get_frontiers();
	void set_feasible(const bool feasibility);
	bool check_feasibility();
	void set_frontiers(const vector<int>& frontiers);
	bool check_feasibility_permutation() const;
	bool check_item_bin_consistency() const;
	bool get_feasibility() const;
	double calculate_fitness(double penalty_factor);
	double objective_function() const;
	static double calculate_bin_penalty(const Bin& bin);
	double calculate_penalty() const;
	int get_num_bins() const;
	void remove_bin(const Bin& bin_to_remove);
	void update_frontiers();
	double penalty;
	double objective;
private:

	double fitness_;
	int item_size_;
	vector<Item> items_;
	vector<Bin> groups_;
	vector<int> frontiers_;
	bool feasible;
};
#endif
