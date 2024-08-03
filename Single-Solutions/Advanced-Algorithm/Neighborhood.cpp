#include "Neighborhood.h"
#include <vector>
#include <random>
#include "Bin.h"
#include "Item.h"
#include <unordered_map>
#include <algorithm>
#include <numeric>
#include <limits>
#include <tuple>
using namespace std;


Neighborhood::Neighborhood() = default;


Result Neighborhood::single_item_move(BinPacking binPacking)
{
	vector<tuple<int, int, int>> changes;
	unordered_map<int, Item> items = binPacking.getItems();
	unordered_map<int, Bin> bins = binPacking.getBins();
	random_device rd;
	mt19937 eng(rd());
	int bins_size = bins.size();
	vector<int> bin_indices(bins_size);
	int bin_index = 0;
	for (auto& bin : bins)
	{
		bin_indices[bin_index] = bin.first;
		bin_index++;
	}
	int items_size = items.size();
	vector<int> item_indices = binPacking.get_items_id();

	shuffle(item_indices.begin(), item_indices.end(), eng);
	bool moved = false;
	for (int item_index : item_indices)
	{
		Item& item = items[item_index];
		shuffle(bin_indices.begin(), bin_indices.end(), eng);
		for (int bin_index : bin_indices)
		{
			Bin& random_bin = bins[bin_index];
			if (random_bin.getId() != item.getBin_id())
			{
				if (random_bin.getCapacity() >= item.getWeight())
				{
					int from_binId = item.getBin_id();
					bins[from_binId].removeFromBin(item);
					// instead of checking empty item list, we can check capacity == bins_capacity
					if (bins[from_binId].getBin_items().empty()) bins.erase(from_binId);
					int to_binId = random_bin.getId();
					item.setBin_id(to_binId);
					random_bin.addToBin(item);
					moved = true;
					tuple new_change = make_tuple(item.getId(), from_binId, to_binId);
					changes.push_back(new_change);
					break;
				}
			}
		}
		if (moved) break;
	}
	BinPacking new_binPacking(items, binPacking.getBins_capacity(), binPacking.getMax_iteration(), binPacking.get_z());
	new_binPacking.set_bins(bins);
	new_binPacking.objective_function();
	new_binPacking.set_items_id(binPacking.get_items_id());
	return { changes, new_binPacking };
}

Result Neighborhood::swap_item(BinPacking binPacking)
{
	vector<tuple<int, int, int>> changes;

	unordered_map<int, Item> items = binPacking.getItems();
	unordered_map<int, Bin> bins = binPacking.getBins();

	int items_size = items.size();
	vector<int> item_indices = binPacking.get_items_id();

	random_device rd;
	mt19937 eng(rd());
	shuffle(item_indices.begin(), item_indices.end(), eng);

	bool swapMade = false;
	int try_count = std::min(15, items_size);
	for (int i = 0; i < try_count; ++i)
	{
		int last_j = 0;
		for (int j = i + 1; j < try_count; ++j)
		{
			int firstIndex = item_indices[i];
			int secondIndex = item_indices[j];

			Item& first_item = items[firstIndex];
			Item& second_item = items[secondIndex];

			int firstBin_Id = first_item.getBin_id();
			int secondBin_id = second_item.getBin_id();

			if (firstBin_Id == secondBin_id) continue;

			int firstBin_available = bins[firstBin_Id].getCapacity() + first_item.getWeight();
			int secondBin_available = bins[secondBin_id].getCapacity() + second_item.getWeight();

			if (firstBin_available >= second_item.getWeight() && secondBin_available >= first_item.getWeight())
			{
				bins[firstBin_Id].removeFromBin(first_item);
				bins[secondBin_id].removeFromBin(second_item);
				second_item.setBin_id(firstBin_Id);
				first_item.setBin_id(secondBin_id);

				bins[firstBin_Id].addToBin(second_item);
				bins[secondBin_id].addToBin(first_item);

				swapMade = true;
				tuple new_change = make_tuple(first_item.getId(), firstBin_Id, secondBin_id);
				changes.push_back(new_change);
				new_change = make_tuple(second_item.getId(), secondBin_id, firstBin_Id);
				changes.push_back(new_change);
				last_j = j;
				break;
			}
		}
		if (swapMade)
		{
			//cout << "swap_item item i: " << i << " with item j: " << last_j << '\n';
			break;
		}
		else
		{
			//cout << "swap_item did not perform" << '\n';

			return single_item_move(binPacking);
		}
	}

	BinPacking new_binPacking(items, binPacking.getBins_capacity(), binPacking.getMax_iteration(), binPacking.get_z());
	new_binPacking.set_bins(bins);
	new_binPacking.objective_function();
	new_binPacking.set_items_id(binPacking.get_items_id());

	return { changes, new_binPacking };
}

// we can find all pairs of bins which are compatible with each other,
// then try to merge one of the pairs
Result Neighborhood::merge_bins(BinPacking binPacking)
{
	vector<tuple<int, int, int>> changes;

	auto items = binPacking.getItems();
	auto bins = binPacking.getBins();
	random_device rd;
	mt19937 eng(rd());
	vector<int> bin_indices;
	for (const auto& bin : bins)
	{
		bin_indices.push_back(bin.first);
	}
	shuffle(bin_indices.begin(), bin_indices.end(), eng);


	bool merged = false;
	int try_count = std::min(static_cast<int>(bin_indices.size()), static_cast<int>(bin_indices.size()));
	for (int i = 0; i < try_count; ++i)
	{

		Bin& bin1 = bins[bin_indices[i]];
		for (int j = i + 1; j < try_count;)
		{
			merged = false;
			Bin& bin2 = bins[bin_indices[j]];
			if (bin2.getUsed_capacity(binPacking.getBins_capacity()) <= bin1.getCapacity())
			{
				for (Item& item : bin2.getBin_items())
				{
					bin1.addToBin(item);
					bin2.removeFromBin(item);
					item.setBin_id(bin1.getId());
					items[item.getId()] = item;
					tuple new_change = make_tuple(item.getId(), bin2.getId(), bin1.getId());
					changes.push_back(new_change);
				}
				if (bins[bin2.getId()].getBin_items().empty())
				{
					bins.erase(bin_indices[j]);
				}
				merged = true;
			}
			else
			{
				++j;
			}
			if (merged) break;
		}
		if (merged) break;
	}
	BinPacking new_binPacking(items, binPacking.getBins_capacity(), binPacking.getMax_iteration(), binPacking.get_z());
	new_binPacking.set_bins(bins);
	new_binPacking.set_items_id(binPacking.get_items_id());
	new_binPacking.objective_function();
	return { changes, new_binPacking };
}

Result Neighborhood::split_bin(BinPacking binPacking)
{
	vector<tuple<int, int, int>> changes;

	auto bins = binPacking.getBins();
	auto items = binPacking.getItems();
	random_device rd;
	mt19937 eng(rd());
	int bins_size = bins.size();
	vector<int> bin_indices(bins_size);
	int bin_index = 0;
	for (auto& bin : bins)
	{
		bin_indices[bin_index] = bin.first;
		bin_index++;
	}
	shuffle(bin_indices.begin(), bin_indices.end(), eng);
	Bin& originalBin = bins[bin_indices[0]];
	auto org_bin_items = originalBin.getBin_items();
	shuffle(org_bin_items.begin(), org_bin_items.end(), eng);
	originalBin.setBin_items(org_bin_items);

	int max_id = *max_element(bin_indices.begin(), bin_indices.end());
	Bin newBin1(max_id + 1, binPacking.getBins_capacity()), newBin2(max_id + 2, binPacking.getBins_capacity());
	bool bin1_turn = true;
	for (Item item : originalBin.getBin_items())
	{
		tuple<int, int, int> new_change;
		if (bin1_turn && newBin1.canAddItem(item))
		{
			originalBin.removeFromBin(item);
			newBin1.addToBin(item);
			item.setBin_id(newBin1.getId());
			bin1_turn = false;
			new_change = make_tuple(item.getId(), originalBin.getId(), newBin1.getId());
		}
		else if (newBin2.canAddItem(item))
		{
			newBin2.addToBin(item);
			originalBin.removeFromBin(item);
			item.setBin_id(newBin2.getId());
			new_change = make_tuple(item.getId(), originalBin.getId(), newBin2.getId());
		}
		items[item.getId()] = item;
		changes.push_back(new_change);
	}
	if (bins[originalBin.getId()].getBin_items().empty()) bins.erase(originalBin.getId());
	if (!newBin1.getBin_items().empty()) bins[newBin1.getId()] = newBin1;
	if (!newBin2.getBin_items().empty()) bins[newBin2.getId()] = newBin2;

	BinPacking new_binPacking(items, binPacking.getBins_capacity(), binPacking.getMax_iteration(), binPacking.get_z());
	new_binPacking.set_bins(bins);
	new_binPacking.set_items_id(binPacking.get_items_id());

	new_binPacking.objective_function();
	return { changes, new_binPacking };
}

Result Neighborhood::item_reinsertion(BinPacking binPacking)
{
	vector<tuple<int, int, int>> changes;
	unordered_map<int, Item> items = binPacking.getItems();
	unordered_map<int, Bin> bins = binPacking.getBins();

	random_device rd;
	mt19937 eng(rd());
	std::uniform_int_distribution<> distr(1, static_cast<int>(items.size()));
	int item_id = distr(eng);
	int bins_size = bins.size();
	vector<int> bin_indices(bins_size);
	int bin_index = 0;
	for (auto& bin : bins)
	{
		bin_indices[bin_index] = bin.first;
		bin_index++;
	}
	Item& item = items[item_id];
	int old_bin_id = item.getBin_id();
	bins[old_bin_id].removeFromBin(item);
	if (bins[old_bin_id].getBin_items().empty()) bins.erase(old_bin_id);
	int max_id = *max_element(bin_indices.begin(), bin_indices.end());
	Bin newBin(max_id + 1, binPacking.getBins_capacity());
	item.setBin_id(max_id + 1);
	newBin.addToBin(item);
	bins[newBin.getId()] = newBin;

	tuple new_change = make_tuple(item.getId(), old_bin_id, newBin.getId());
	changes.push_back(new_change);
	BinPacking new_binPacking(items, binPacking.getBins_capacity(), binPacking.getMax_iteration(), binPacking.get_z());
	new_binPacking.set_bins(bins);
	new_binPacking.objective_function();
	new_binPacking.set_items_id(binPacking.get_items_id());

	return { changes, new_binPacking };
}

Result Neighborhood::empty_bin(BinPacking binPacking)
{
	vector<tuple<int, int, int>> changes;
	unordered_map<int, Item> items = binPacking.getItems();
	unordered_map<int, Bin> bins = binPacking.getBins();

	int bins_size = bins.size();

	vector<int> bin_indices(bins_size);
	int bin_index = 0;
	for (auto& bin : bins)
	{
		bin_indices[bin_index] = bin.first;
		bin_index++;
	}

	random_device rd;
	mt19937 eng(rd());
	std::uniform_int_distribution<> distr(0, bins_size - 1);
	bin_index = distr(eng);
	int bin_id = bin_indices[bin_index];
	Bin& bin = bins[bin_id];
	vector<Item> bin_items = bin.getBin_items();

	for (Item& bin_item : bin_items) {
		Item& item = items[bin_item.getId()];
		bool placed = false;
		for (auto& [id, other_bin] : bins) {
			if (id != bin_id && other_bin.getCapacity() >= item.getWeight()) {
				bin.removeFromBin(item);
				item.setBin_id(other_bin.getId());
				other_bin.addToBin(item);
				changes.emplace_back(item.getId(), bin_id, id);
				placed = true;
				break;
			}
		}
		if (!placed) {
			continue;
		}
	}
	if (bins[bin_id].getBin_items().empty()) bins.erase(bin_id);
	BinPacking new_binPacking(items, binPacking.getBins_capacity(), binPacking.getMax_iteration(), binPacking.get_z());
	new_binPacking.set_bins(bins);
	new_binPacking.objective_function();
	new_binPacking.set_items_id(binPacking.get_items_id());

	return { changes, new_binPacking };
}

// every time a neighborhood definition be added, this func should be adjusted
Result Neighborhood::call_tweak(FunctionID func, const BinPacking& binPacking)
{
	switch (func)
	{
		/*case SingleItemMove:
			return single_item_move(binPacking);
			break;*/
	case Swap:
		return swap_item(binPacking);
		break;
		/*case MergeBins:
			return merge_bins(binPacking);
			break;*/
	case EmptyBin:
		return empty_bin(binPacking);
		break;
		/*case SplitBin:
			return split_bin(binPacking);
			break;*/
			/*case ItemReinsertion:
				return item_reinsertion(binPacking);
				break;*/
	default:
		return swap_item(binPacking);
		break;
	}
}

FunctionID Neighborhood::select_tweak()
{
	double totalScore = accumulate(tweak_probabilities.begin(), tweak_probabilities.end(), 0.0);
	random_device rd;
	mt19937 gen(rd());
	uniform_real_distribution<> dis(0.0, totalScore);
	double randomScore = dis(gen);
	double cumulativeScore = 0;

	for (int i = 0; i < tweak_numbers; i++)
	{
		cumulativeScore += tweak_probabilities[i];
		if (randomScore <= cumulativeScore)
		{
			return static_cast<FunctionID>(i);
		}
	}
	return Swap;
}

void Neighborhood::setTweak_probabilities(const vector<double>& tweak_probabilities)
{
	this->tweak_probabilities = tweak_probabilities;
}

std::vector<double> Neighborhood::getTweak_probabilities()
{
	return tweak_probabilities;
}

vector<double> Neighborhood::reassign_probabilities()
{
	vector<double> denominators;
	denominators.reserve(tweak_numbers);
	vector<double> probabilities;
	probabilities.reserve(tweak_numbers);

	for (int i = 0; i < this->tweak_numbers; i++)
	{
		vector<int> rewards = this->RD[i];
		int rewards_sum = accumulate(rewards.begin(), rewards.end(), 0);
		double safe_reward = rewards_sum == 0 ? std::numeric_limits<double>::epsilon() : rewards_sum;
		vector<int> penalties = this->PN[i];
		int penalties_sum = accumulate(penalties.begin(), penalties.end(), 0);
		double value = rewards_sum / (safe_reward + penalties_sum);
		denominators.push_back(value);
	}

	double denominators_sum = accumulate(denominators.begin(), denominators.end(), 0.0);
	for (int i = 0; i < this->tweak_numbers; i++)
	{
		double probability = denominators[i] / denominators_sum;
		probabilities.push_back(probability);
	}

	// Adjust zero probabilities and normalize
	bool adjusted = false;
	double small_value = 0.01;
	double sum = 0.0; // To recalculate the sum of probabilities

	for (double& probability : probabilities)
	{
		if (probability == 0)
		{
			probability = small_value;
			adjusted = true;
		}
		sum += probability;
	}

	if (adjusted)
	{
		for (double& probability : probabilities)
		{
			probability /= sum; // Normalize to ensure sum is 1
		}
	}

	return probabilities;
}

BinPacking Neighborhood::multiple_item_move(BinPacking binPacking)
{
	unordered_map<int, Item> items = binPacking.getItems();
	unordered_map<int, Bin> bins = binPacking.getBins();
	random_device rd;
	mt19937 eng(rd());
	int bins_size = bins.size();
	vector<int> bin_indices(bins_size);
	int bin_index = 0;
	for (auto& bin : bins)
	{
		bin_indices[bin_index] = bin.first;
		bin_index++;
	}

	int items_size = items.size();
	vector<int> item_indices = binPacking.get_items_id();

	shuffle(item_indices.begin(), item_indices.end(), eng);

	return binPacking;
}


