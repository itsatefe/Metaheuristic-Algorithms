#include "Crossover.h"
#include <random>
#include <unordered_map>
#include <algorithm>
#include <iostream>
#include <set>
#include <vector>
#include "Bin.h"
#include "Chromosome.h"

using namespace std;

// Uniform order-based crossover and other crossover functions
struct Points
{
	int items_start;
	int items_end;
	int groups_start;
	int groups_end;
};

Points get_points(Chromosome parent, int num_consecutive_groups)
{
	random_device rd;
	mt19937 gen(rd());
	int num_groups = parent.get_groups().size();
	if (num_consecutive_groups == num_groups)
		return {
			0, static_cast<int>(parent.get_values().size()) - 1, 0, num_groups - 1
	};
	uniform_int_distribution<> start_point_dist(0, num_groups - num_consecutive_groups);
	int point1 = start_point_dist(gen);
	int point2 = point1 + num_consecutive_groups - 1;
	if (point1 == 0) return { 0, parent.get_frontiers()[point2], 0, point2 };
	return { parent.get_frontiers()[point1 - 1] + 1, parent.get_frontiers()[point2], point1, point2 };
}

pair<Chromosome, Chromosome> swap_groups(Chromosome parent1, Points points1, Chromosome parent2, Points points2)
{
	vector<Bin>& groups1 = parent1.get_groups();
	vector<Bin>& groups2 = parent2.get_groups();

	// Extract groups for remapping bin_ids
	vector<Bin> extracted_groups1(groups1.begin() + points1.groups_start, groups1.begin() + points1.groups_end + 1);
	vector<Bin> extracted_groups2(groups2.begin() + points2.groups_start, groups2.begin() + points2.groups_end + 1);

	// Remove items and groups from the specified ranges
	groups1.erase(groups1.begin() + points1.groups_start, groups1.begin() + points1.groups_end + 1);
	groups2.erase(groups2.begin() + points2.groups_start, groups2.begin() + points2.groups_end + 1);

	// Insert items and groups from the opposite parent
	groups1.insert(groups1.begin() + points1.groups_start, extracted_groups2.begin(), extracted_groups2.end());
	groups2.insert(groups2.begin() + points2.groups_start, extracted_groups1.begin(), extracted_groups1.end());

	// Reassign all bin IDs to maintain consistency
	auto reassignBinIDs = [&](vector<Bin>& bins) -> vector<Item>
		{
			int nextBinID = 0;
			vector<Item> new_items;
			for (Bin& bin : bins)
			{
				bin.set_id(nextBinID++);
				auto& items_in_bin = bin.get_items();
				for (auto& [id, item] : items_in_bin)
				{
					item.set_bin_id(bin.get_id());
					new_items.push_back(item);
				}
			}
			return new_items;
		};

	vector<Item> new_items1 = reassignBinIDs(groups1);
	vector<Item> new_items2 = reassignBinIDs(groups2);

	parent1.set_values(new_items1);
	parent2.set_values(new_items2);
	return { parent1, parent2 };
}

void update_frontiers(Chromosome& offspring)
{
	vector<Item>& items = offspring.get_values();
	vector<int> frontiers = offspring.get_frontiers();
	frontiers.clear();

	if (items.empty()) return;

	int current_group = items[0].get_bin_id();
	for (int i = 0; i < items.size(); ++i)
	{
		if (items[i].get_bin_id() != current_group)
		{
			frontiers.push_back(i - 1);
			current_group = items[i].get_bin_id();
		}
		if (i == items.size() - 1)
		{
			frontiers.push_back(i);
		}
	}
	offspring.set_frontiers(frontiers);
}

void repair_offspring(Chromosome& child, Chromosome& original, int point1, int point2)
{
	vector<Item>& child_values = child.get_values();
	const vector<Item>& original_values = original.get_values();
	unordered_map<int, Item> originalItems;
	unordered_map<int, int> itemCounts;
	vector<int> emptyPositions;
	random_device rd;
	mt19937 gen(rd());

	vector<Bin>& bins = child.get_groups();

	// Populate the map with original items
	for (const Item& item : original_values)
	{
		originalItems[item.get_id()] = item;
		itemCounts[item.get_id()] = 0;
	}

	// Count occurrences of each item in the child
	for (const auto& child_value : child_values)
	{
		itemCounts[child_value.get_id()]++;
	}

	// Choose bins outside the swap range for reinserting missing items
	set<int> validBinIndices;
	int j = 0;
	for (int i = 0; i < bins.size(); ++i)
	{
		for (const auto& [id, item] : bins[i].get_items())
		{
			if (j < point1 || j > point2)
			{
				// Assuming bin indices align with item indices
				validBinIndices.insert(item.get_bin_id());
			}
			j++;
		}
	}

	// Remove duplicates outside the swap range and mark positions
	for (int i = 0; i < child_values.size(); ++i)
	{
		int id = child_values[i].get_id();
		if (itemCounts[id] > 1)
		{
			if (i < point1 || i > point2)
			{
				itemCounts[id]--;
				int bin_id = child_values[i].get_bin_id();
				bins[bin_id].remove_item(child_values[i].get_id());
				child_values[i] = Item();
				emptyPositions.push_back(i);
			}
		}
	}

	// Find missing items
	vector<Item> missingItems;
	for (const auto& pair : originalItems)
	{
		if (itemCounts[pair.first] == 0)
		{
			missingItems.push_back(pair.second);
		}
	}

	// Reinsert missing items into available empty positions and assign them to valid bins
	size_t minSize = min(missingItems.size(), emptyPositions.size());
	for (size_t i = 0; i < minSize; ++i)
	{
		if (!validBinIndices.empty())
		{
			uniform_int_distribution<> binDist(0, validBinIndices.size() - 1);
			auto it = validBinIndices.begin(); // Obtain an iterator to the start of the set
			std::advance(it, binDist(gen));
			int randomBinId = *it;
			bins[randomBinId].place_item_feasible_randomly(missingItems[i]);
			missingItems[i].set_bin_id(randomBinId);
			bins[randomBinId].add_item(missingItems[i]);
			child_values[emptyPositions[i]] = missingItems[i];

		}
	}
	emptyPositions.erase(emptyPositions.begin(), emptyPositions.begin() + minSize);

	if (!emptyPositions.empty())
	{
		ranges::sort(emptyPositions, greater<int>());
		for (int pos : emptyPositions)
		{
			if (pos < child_values.size())
			{
				child_values.erase(child_values.begin() + pos);
			}
		}
	}

	// Handle any leftover missing items by adding them to the end of the child_values vector
	if (missingItems.size() > emptyPositions.size())
	{
		for (size_t i = minSize; i < missingItems.size(); ++i)
		{
			if (!validBinIndices.empty())
			{
				// Select a bin based on some criteria (e.g., random, least full, etc.)
				uniform_int_distribution<> binDist(0, validBinIndices.size() - 1);
				auto it = validBinIndices.begin(); // Obtain an iterator to the start of the set
				std::advance(it, binDist(gen));
				int randomBinId = *it;

				// Find a position close to other items in the same bin if possible
				vector<int> possiblePositions;
				for (int j = 0; j < child_values.size(); ++j)
				{
					if (child_values[j].get_bin_id() == randomBinId)
					{
						possiblePositions.push_back(j); // Collect positions of items in the same bin
					}
				}

				int randomPos;
				if (!possiblePositions.empty())
				{
					// If there are other items in the same bin, insert close to one of them
					uniform_int_distribution<> posDist(0, possiblePositions.size() - 1);
					randomPos = possiblePositions[posDist(gen)] + 1;
					// Insert right after a randomly selected item in the same bin
				}
				else
				{
					// If no items are in the bin, insert at a random position
					uniform_int_distribution<> posDist(0, child_values.size());
					randomPos = posDist(gen);
				}
				bins[randomBinId].place_item_feasible_randomly(missingItems[i]);

				// Set the bin ID and insert the item
				missingItems[i].set_bin_id(randomBinId);
				bins[randomBinId].add_item(missingItems[i]);
				child_values.insert(child_values.begin() + randomPos, missingItems[i]);

			}
		}
	}

	auto it = remove_if(bins.begin(), bins.end(), [](Bin& bin)
		{
			return bin.get_items().empty();
		});
	bins.erase(it, bins.end());

	auto reassignBinIDs = [&](vector<Bin>& groups) -> vector<Item>
		{
			int nextBinID = 0;
			vector<Item> new_items;
			for (Bin& bin : groups)
			{
				bin.set_id(nextBinID++);
				auto& items_in_bin = bin.get_items();
				for (auto& [id, item] : items_in_bin)
				{
					item.set_bin_id(bin.get_id());
					new_items.push_back(item);
				}
			}
			return new_items;
		};

	vector<Item> new_items1 = reassignBinIDs(bins);
	child.set_values(new_items1);
}

vector<Chromosome> Crossover::swap_two_point(Chromosome parent1, Chromosome parent2)
{
	random_device rd;
	mt19937 gen(rd());
	int num_groups1 = static_cast<int>(parent1.get_groups().size());
	int num_groups2 = static_cast<int>(parent2.get_groups().size());
	int num_groups = min(num_groups1, num_groups2);
	// Generating a random number for the number of groups to involve in crossover
	// num consecutive groups can be limited depending on size of items
	uniform_int_distribution<> group_count_dist(1, num_groups);
	int num_consecutive_groups = group_count_dist(gen);
	if (num_consecutive_groups == num_groups)
	{
		return { parent2, parent1 };
	}
	Points offspring1_points = get_points(parent1, num_consecutive_groups);
	Points offspring2_points = get_points(parent2, num_consecutive_groups);

	auto [offspring1, offspring2] = swap_groups(parent1, offspring1_points, parent2, offspring2_points);

	repair_offspring(offspring1, parent1, offspring1_points.items_start,
		offspring1_points.items_start + offspring2_points.items_end - offspring2_points.items_start);
	repair_offspring(offspring2, parent2, offspring2_points.items_start,
		offspring2_points.items_start + offspring1_points.items_end - offspring1_points.items_start);


	return { offspring1, offspring2 };
}
