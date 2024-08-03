#ifndef BINPACKING_H
#define BINPACKING_H

#include <vector>
#include <iostream>
#include "Item.h"
#include "Bin.h"
#include <unordered_map>

using namespace std;

class BinPacking
{
public:
	// last bin id
	BinPacking(const unordered_map<int, Item>& items, int bins_capacity, int max_iteration, int z);
	BinPacking(const BinPacking& other);
	unordered_map<int, Item> getItems();
	int getBins_capacity() const;
	void displayItems() const;
	void displayBins() const;
	void addItem(const Item& item);
	void addBin(const Bin& bin);
	unordered_map<int, Bin> getBins();
	void random_bins_init();
	bool is_any_item_fit(int remain_capacity);
	int sumItems_weight();
	bool check_feasibility();
	double objective_function();
	void greedy_bins_init();
	int getMax_iteration() const;
	void setMax_iteration(int max_iteration);
	void set_bins(unordered_map<int, Bin> bins);
	int get_z();
	int getTotal_weight();
	int getItems_size() const;
	void set_items(unordered_map<int, Item> items);
	double get_objective() const;
	void set_objective();
	vector<int> get_items_id();
	void set_items_id(const vector<int>& items_id);
	
private:
	vector<int> items_id;
	double objective;
	unordered_map<int, Item> items;
	unordered_map<int, Bin> bins;
	int bins_capacity;
	int items_size;
	int z; // for objective function usually is set to 2
	int max_iteration;
	int total_weight;
	int calculateTotal_weight() const;
};

#endif
