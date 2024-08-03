#include "BinPacking.h"
#include "Bin.h"
#include <random>
#include <iostream>
#include <algorithm>
#include <unordered_map>
#include <cmath>

using namespace std;


bool compareByWeight(const Item& a, const Item& b)
{
	return a.getWeight() < b.getWeight();
}

BinPacking::BinPacking(const unordered_map<int, Item>& items, int bins_capacity, int max_iteration, int z)
{
	this->bins_capacity = bins_capacity;
	this->items = items;
	this->items_size = static_cast<int>(items.size());
	this->z = z; //for objective function
	this->max_iteration = max_iteration;
	//int value = 10 * items_size * static_cast<int>(log(bins_capacity));
	//this->max_iteration = value > max_iteration ? value : max_iteration + value;
	this->total_weight = calculateTotal_weight();
	//this->max_iteration = items_size * (total_weight / bins_capacity);
	//this->max_iteration = 2000;
}


BinPacking::BinPacking(const BinPacking& other)
	: items(other.items),
	bins(other.bins),
	bins_capacity(other.bins_capacity),
	items_size(other.items_size),
	z(other.z),
	max_iteration(other.max_iteration),
	total_weight(other.total_weight),
	objective(other.objective),
	items_id(other.items_id)
{
}

void BinPacking::displayItems() const
{
	cout << "Items:" << endl;
	for (const auto& item : items)
	{
		cout << "- Item id: " << item.first << " with weight: " << item.second.getWeight() << endl;
	}
}

void BinPacking::displayBins() const
{
	for (const auto& bin : bins)
	{
		std::cout << "-----------" << std::endl;
		std::cout << "Bin id: " << bin.second.getId() << " Bin remaining capacity: " << bin.second.getCapacity() <<
			std::endl;
		for (const auto& item : bin.second.getBin_items())
		{
			std::cout << "Item id: " << item.getId() << " Item weight: " << item.getWeight() << std::endl;
		}
	}
}

int BinPacking::getBins_capacity() const
{
	return bins_capacity;
}

unordered_map<int, Item> BinPacking::getItems()
{
	return items;
}

unordered_map<int, Bin> BinPacking::getBins()
{
	return bins;
}

void BinPacking::addBin(const Bin& bin)
{
	bins[bin.getId()] = bin;
}

void BinPacking::addItem(const Item& item)
{
	items[item.getId()] = item;
}

void BinPacking::random_bins_init()
{
	random_device rd;
	mt19937 eng(rd());
	uniform_int_distribution<> distr(0, 1);

	vector<Item*> unplacedItems;
	for (auto& item : items)
	{
		if (!item.second.getIs_used())
		{
			unplacedItems.push_back(&item.second);
		}
	}
	int binId = 0;
	while (!unplacedItems.empty())
	{
		Bin newBin(binId++, bins_capacity);
		bool added = false;

		shuffle(unplacedItems.begin(), unplacedItems.end(), eng);

		for (auto it = unplacedItems.begin(); it != unplacedItems.end();)
		{
			Item* item = *it;
			if (item->getWeight() <= newBin.getCapacity())
			{
				newBin.addToBin(*item);
				item->setIs_used(true);
				item->setBin_id(newBin.getId());
				added = true;
				it = unplacedItems.erase(it);
			}
			else
			{
				++it;
			}
			if (distr(eng) == 1) break;
		}

		if (added)
		{
			bins[newBin.getId()] = newBin;
		}
		else
		{
			binId--;
			throw std::logic_error("Cannot place all items into bins without exceeding capacity.");
		}
	}
	objective = objective_function();
}

void BinPacking::greedy_bins_init()
{
	int count_items = 0;
	int bin_id = -1;

	random_device rd;
	mt19937 eng(rd());
	uniform_int_distribution<> distr(1, items_size);
	while (count_items < items_size)
	{
		Bin new_bin(++bin_id, bins_capacity);
		while (is_any_item_fit(new_bin.getCapacity()))
		{
			int random_number = distr(eng);
			Item& selected_item = items[random_number];
			if (!selected_item.getIs_used())
			{
				if (new_bin.getCapacity() >= selected_item.getWeight())
				{
					new_bin.addToBin(selected_item);
					count_items++;
					selected_item.setIs_used(true);
					selected_item.setBin_id(new_bin.getId());
				}
			}
		}
		bins[new_bin.getId()] = new_bin;
	}
}

bool BinPacking::is_any_item_fit(int remain_capacity)
{
	vector<Item> unusedItems;
	for (const auto& item : items)
	{
		if (!item.second.getIs_used())
		{
			unusedItems.push_back(item.second);
		}
	}
	if (!unusedItems.empty())
	{
		sort(unusedItems.begin(), unusedItems.end(), compareByWeight);
		Item firstItem = unusedItems.front();
		return firstItem.getWeight() < remain_capacity;
	}
	return false;
}

int BinPacking::sumItems_weight()
{
	int sum_weight = 0;
	for (auto& item : items)
	{
		sum_weight += item.second.getWeight();
	}
	return sum_weight;
}

bool BinPacking::check_feasibility()
{
	int weight = 0;
	int sum_weight = 0;
	for (auto bin : bins)
	{
		weight = 0;
		for (Item item : bin.second.getBin_items())
		{
			weight += item.getWeight();
		}
		sum_weight += weight;
		if (weight > bins_capacity) return false;
	}
	if (sum_weight != sumItems_weight()) return false;
	return true;
}

double BinPacking::objective_function()
{
	double ratio = 0;
	for (auto bin : bins)
	{
		double a = ((bins_capacity - bin.second.getCapacity()) / static_cast<double>(bins_capacity));
		ratio += pow(a, z);
	}
	ratio /= bins.size();
	objective = 1 - ratio;
	return objective;
}

int BinPacking::getMax_iteration() const
{
	return max_iteration;
}

void BinPacking::setMax_iteration(int max_iteration)
{
	this->max_iteration = max_iteration;
}

void BinPacking::set_bins(unordered_map<int, Bin> bins)
{
	this->bins = bins;
}

int BinPacking::get_z()
{
	return z;
}

int BinPacking::getTotal_weight()
{
	return total_weight;
}

int BinPacking::getItems_size() const
{
	return items.size();
}

void BinPacking::set_items(unordered_map<int, Item> items)
{
	this->items = items;
}

int BinPacking::calculateTotal_weight() const
{
	int totalWeight = 0;
	for (const auto& pair : items)
	{
		totalWeight += pair.second.getWeight();
	}
	return totalWeight;
}

double BinPacking::get_objective() const
{
	return objective;
}

void BinPacking::set_objective()
{
	this->objective = objective_function();
}

vector<int> BinPacking::get_items_id()
{
	return items_id;
}

void BinPacking::set_items_id(const vector<int>& items_id)
{
	this->items_id = items_id;
}
