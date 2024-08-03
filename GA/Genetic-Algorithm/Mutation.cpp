#include "Mutation.h"

#include <iostream>
#include <numeric>

#include "Bin.h"
#include <random>
#include "RectanglePlacement.h"

using namespace RectanglePlacement;
using namespace std;
unordered_map<int, vector<int>> Mutation::RD;
unordered_map<int, vector<int>> Mutation::PN;

//Heuristic based mutation for rearrangement of a subset of items (or a bin)

// first check if the item can be placed in the unoccupied spaces
// if not then try to merge
// and while merging check again to early exit
bool Mutation::feasible_insert(Item& item, Bin& bin)
{
	auto unoccupied_areas = detect_unoccupied_areas(bin.get_items(), bin.get_width(), bin.get_height());
	Bin old = bin;

	auto [placed_rect, unoccupied_bin_area] = place_rectangle(item.get_width(), item.get_height(), unoccupied_areas);
	bin.set_unoccupied_area(unoccupied_bin_area);
	if (get<0>(placed_rect) != -1)
	{
		int x = get<0>(placed_rect);
		int y = get<1>(placed_rect);
		if (x + item.get_width() > bin.get_width() || x < 0 || y + item.get_height() > bin.get_height() || y < 0)
			return false;
		item.set_xy(x, y);
		bin.add_item(item);
		if (old.check_bin_feasibility())
			if (!bin.check_bin_feasibility())
			{
				cout << "new x: " << x << " new y: " << y << '\n';
				cout << "old bin" << '\n';
				old.display_bin();
				cout << "new bin" << '\n';
				bin.display_bin();
				cout << "bin feasibility: " << boolalpha << false << '\n';
				for (auto it = unoccupied_areas.begin(); it != unoccupied_areas.end(); ++it)
				{
					int x1, x2, y1, y2;
					std::tie(x1, x2, y1, y2) = *it;
					cout << "x1: " << x1 << " x2: " << x2 << " y1: " << y1 << " y2: " << y2 << '\n';
				}
			}
		return true;
	}
	return false;
}

void Mutation::randomly_insert(Item& item, Bin& bin)
{
	random_device rd;
	mt19937 gen(rd());
	uniform_int_distribution<> width_int_dis(0, bin.get_width() - item.get_width());
	uniform_int_distribution<> height_int_dis(0, bin.get_height() - item.get_height());
	int x = width_int_dis(gen);
	int y = height_int_dis(gen);
	item.set_xy(x, y);
	bin.add_item(item);
}

// randomly select a bin
// select one item within bin if its x,y is out of the bin boundaries
// try to pull it inside the bin boundaries by focusing its x or y
Chromosome Mutation::item_exceed_removal(Chromosome offspring)
{
	random_device rd;
	mt19937 gen(rd());
	vector<Bin>& bins = offspring.get_groups();
	uniform_int_distribution<> dis_bins(0, static_cast<int>(bins.size() - 1));
	int bin_index = dis_bins(gen);
	Bin& bin = bins[bin_index];
	unordered_map<int, Item>& items = bin.get_items();
	for (auto& [id, item] : items)
	{
		Overlap exceeds = bin.exceeds_item(item);
		if (!exceeds.exists) continue;
		if (exceeds.direction == TOP || exceeds.direction == BOTH)
		{
			int top_exceed = (item.y + item.get_height()) - bin.get_height();
			item.y -= top_exceed;
		}
		if (exceeds.direction == RIGHT || exceeds.direction == BOTH)
		{
			int right_exceed = (item.x + item.get_width()) - bin.get_width();
			item.y -= right_exceed;
		}
	}
	return offspring;
}

Chromosome Mutation::item_overlap_removal(Chromosome offspring)
{
	random_device rd;
	mt19937 gen(rd());
	if (offspring.get_feasibility()) return offspring;

	vector<Bin>& bins = offspring.get_groups();
	for (Bin& bin : bins)
	{
		unordered_map<int, Item>& bin_items = bin.get_items();
		vector<pair<Item, Item>> immediate_overlapped_items = bin.get_immediate_overlapped_items();
		if (!bin.get_bin_feasibility())
		{
			if (immediate_overlapped_items.empty()) bin.set_bin_feasibility(true);
		}
		if (!bin.get_bin_feasibility())
		{
			uniform_int_distribution<> dis(0, static_cast<int>(immediate_overlapped_items.size()) - 1);
			int index = dis(gen);
			int item_first_id = immediate_overlapped_items[index].first.get_id();
			int item_second_id = immediate_overlapped_items[index].second.get_id();

			Item temp_first = bin.find_item_by_value(item_first_id);
			Item temp_second = bin.find_item_by_value(item_second_id);
			if (temp_second < temp_first) swap(temp_first, temp_second);

			Item& item_first = bin.find_item_by_ref(temp_first.get_id());
			Item& item_second = bin.find_item_by_ref(temp_second.get_id());

			Overlap overlap = Bin::is_overlapping(item_first, item_second);

			if (overlap.direction == HORIZONTAL || overlap.direction == BOTH)
			{
				if (item_first.x - item_second.x < (2 * item_second.x) + item_second.get_width() - item_first.x)
				{
					item_first.x = max(0, item_second.x - item_first.get_width());
				}
				else
				{
					item_first.x = min(bin.get_width() - item_first.get_width(),
						item_second.x + item_second.get_width());
				}
			}
			else if (overlap.direction == VERTICAL)
			{
				if (item_first.y - item_second.y < (2 * item_second.y) + item_second.get_height() - item_first.y)
				{
					item_first.y = max(0, item_second.y - item_first.get_height());
				}
				else
				{
					item_first.y = min(bin.get_height() - item_first.get_height(),
						item_second.y + item_second.get_height());
				}
			}
			/*bin_items[item_first.get_id()] = item_first;
			bin_items[item_second.get_id()] = item_second;*/
		}
	}
	// how about checking modified bin feasibility instead
	// in this case check_feasibility function should be adjusted
	return offspring;
}


// select two items that have overlap with each other
// choose one (bigger or smaller) and move it to other bin
// when moving an item into a feasible bin, insert it with check
// else insert anywhere randomly
Chromosome Mutation::random_reinsert_mutation(Chromosome offspring)
{
	random_device rd;
	mt19937 gen(rd());
	vector<Bin>& bins = offspring.get_groups();
	if (bins.size() == 1) return offspring;
	uniform_int_distribution<> dis_bin(0, static_cast<int>(bins.size()) - 1);
	int bin_index = dis_bin(gen);
	Bin& bin = bins[bin_index];
	int first_item_id = select_item(bin);
	Item first_item = bin.find_item_by_value(first_item_id);
	bin_index = dis_bin(gen);
	while (bins[bin_index].get_id() == bin.get_id()) bin_index = dis_bin(gen);

	Bin& second_bin = bins[bin_index];
	bin.remove_item(first_item_id);
	randomly_insert(first_item, second_bin);
	if (bin.get_items().empty())
	{
		offspring.remove_bin(bin);
	}
	return offspring;
}

Chromosome Mutation::feasible_reinsert_mutation(Chromosome offspring)
{
	Chromosome old_offspring = offspring;
	random_device rd;
	mt19937 gen(rd());
	vector<Bin>& bins = offspring.get_groups();
	if (bins.size() == 1) return offspring;
	uniform_int_distribution<> dis_bin(0, static_cast<int>(bins.size()) - 1);
	int bin_index = dis_bin(gen);
	Bin& bin = bins[bin_index];
	int first_item_id = select_item(bin);
	Item first_item = bin.find_item_by_value(first_item_id);
	bin_index = dis_bin(gen);
	while (bins[bin_index].get_id() == bin.get_id()) bin_index = dis_bin(gen);

	Bin& second_bin = bins[bin_index];

	bool is_fit = second_bin.can_fit(first_item);
	if (!is_fit) return old_offspring;

	bin.remove_item(first_item_id);

	if (!feasible_insert(first_item, second_bin))
	{
		return old_offspring;
	}
	/*vector<Item>& offspring_items = offspring.get_values();
	auto it = ranges::find_if(offspring_items, [first_item_id](const Item& obj) {
		return obj.get_id() == first_item_id;
		});

	if (it == offspring_items.end()) {
		throw runtime_error("Error: Not finding id in offspring values!!");
	}*/
	//it->set_xy(first_item.x, first_item.y);


	if (bin.get_items().empty())
	{
		offspring.remove_bin(bin);
	}
	return offspring;
}


// swap two items that is involved into
// an overlap between two bins with each other
Chromosome Mutation::random_between_swap_mutation(Chromosome offspring)
{
	random_device rd;
	mt19937 gen(rd());
	vector<Bin>& bins = offspring.get_groups();
	if (bins.size() == 1) return offspring;
	uniform_int_distribution<> dis_bin(0, static_cast<int>(bins.size()) - 1);
	int bin_index1 = dis_bin(gen);
	Bin& bin1 = bins[bin_index1];
	int bin_index2 = dis_bin(gen);
	while (bins[bin_index2].get_id() == bin1.get_id()) bin_index2 = dis_bin(gen);
	Bin& bin2 = bins[bin_index2];
	int first_item_id = select_item(bin1);
	int second_item_id = select_item(bin2);
	Item first_item = bin1.find_item_by_value(first_item_id);
	Item second_item = bin2.find_item_by_value(second_item_id);

	bin1.remove_item(first_item_id);
	bin2.remove_item(second_item_id);
	randomly_insert(first_item, bin2);
	randomly_insert(second_item, bin1);
	return offspring;
}

Chromosome Mutation::feasible_between_swap_mutation(Chromosome offspring)
{
	Chromosome old_offspring = offspring;
	random_device rd;
	mt19937 gen(rd());
	vector<Bin>& bins = offspring.get_groups();
	if (bins.size() == 1) return offspring;
	uniform_int_distribution<> dis_bin(0, static_cast<int>(bins.size()) - 1);
	int bin_index1 = dis_bin(gen);
	Bin& bin1 = bins[bin_index1];
	int bin_index2 = dis_bin(gen);
	while (bins[bin_index2].get_id() == bin1.get_id()) bin_index2 = dis_bin(gen);
	Bin& bin2 = bins[bin_index2];
	int first_item_id = select_item(bin1);
	int second_item_id = select_item(bin2);
	Item first_item = bin1.find_item_by_value(first_item_id);
	Item second_item = bin2.find_item_by_value(second_item_id);


	bool is_fit = bin1.can_fit(second_item);
	if (!is_fit) return old_offspring;
	is_fit = bin2.can_fit(first_item);
	if (!is_fit) return old_offspring;

	bin1.remove_item(first_item_id);
	bin2.remove_item(second_item_id);
	if (!feasible_insert(first_item, bin2))
	{
		return old_offspring;
	}
	if (!feasible_insert(second_item, bin1))
	{
		return old_offspring;
	}

	return offspring;
}


// empty a bin
// place its items into other bins
// from bins which has overlap items
// select one of them
// insert into other bins feasible
Chromosome Mutation::empty_bin_mutation(Chromosome offspring)
{
	random_device rd;
	mt19937 gen(rd());
	vector<Bin>& bins = offspring.get_groups();
	if (bins.size() == 1) return offspring;
	uniform_int_distribution<> dis_bin(0, static_cast<int>(bins.size()) - 1);
	int bin_index1 = dis_bin(gen);
	Bin& bin1 = bins[bin_index1];
	ranges::shuffle(bins, gen);
	Bin bin = bin1;
	for (auto [id, item] : bin.get_items())
	{
		for (auto& other_bin : bins)
		{
			if (bin1.get_id() != other_bin.get_id() && other_bin.can_fit(item))
			{
				//Item first_item = bin1.find_item_by_value(id);
				if (feasible_insert(item, other_bin))
				{
					bin1.remove_item(id);
					break;
				}
			}
		}
	}
	if (bin1.get_items().empty()) offspring.remove_bin(bin1);
	return offspring;
}


// swap one of items that is involved into
// an overlap within their own bins with another item
Chromosome Mutation::within_swap_mutation(Chromosome offspring)
{
	return offspring;
}


// every time a neighborhood definition be added, this func should be adjusted
Chromosome Mutation::apply_mutation(FunctionID func, Chromosome offspring)
{
	switch (func)
	{
	case Item_Overlap:
		return item_overlap_removal(offspring);
		break;
	case Random_Reinsert:
		return random_reinsert_mutation(offspring);
		break;
	case Feasible_Reinsert:
		return feasible_reinsert_mutation(offspring);
		break;
		/*case Within_Swap:
			return within_swap_mutation(offspring);
			break;*/
	case Random_Between_Swap:
		return random_between_swap_mutation(offspring);
		break;
	case Feasible_Between_Swap:
		return feasible_between_swap_mutation(offspring);
		break;
	/*case Empty_Bin:
		return empty_bin_mutation(offspring);
		break;*/
	}
	return offspring;
}

FunctionID Mutation::select_tweak(vector<double> tweak_probabilities)
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
	return Feasible_Reinsert;
}

vector<double> Mutation::reassign_probabilities()
{
	vector<double> denominators;
	denominators.reserve(tweak_numbers);
	vector<double> probabilities;
	probabilities.reserve(tweak_numbers);

	for (int i = 0; i < tweak_numbers; i++)
	{
		vector<int> rewards = RD[i];
		int rewards_sum = accumulate(rewards.begin(), rewards.end(), 0);
		double safe_reward = rewards_sum == 0 ? numeric_limits<double>::epsilon() : rewards_sum;
		vector<int> penalties = PN[i];
		int penalties_sum = accumulate(penalties.begin(), penalties.end(), 0);
		double value = rewards_sum / (safe_reward + penalties_sum);
		denominators.push_back(value);
	}

	double denominators_sum = accumulate(denominators.begin(), denominators.end(), 0.0);
	if (denominators_sum == 0.0)
	{
		for (int i = 0; i < tweak_numbers; i++)
		{
			double probability = 1 / static_cast<double>(tweak_numbers);
			probabilities.push_back(probability);
		}
		return probabilities;
	}

	for (int i = 0; i < tweak_numbers; i++)
	{
		double probability = denominators[i] / denominators_sum;
		probabilities.push_back(probability);
	}

	bool adjusted = false;
	double small_value = 0.01;
	double sum = 0.0;

	for (double& probability : probabilities)
	{
		if (probability == 0.0)
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
			probability /= sum;
		}
	}

	return probabilities;
}

int Mutation::select_item(Bin& bin)
{
	random_device rd;
	mt19937 gen(rd());
	unordered_map<int, Item>& bin_items = bin.get_items();
	int first_item_id = 0;
	vector<pair<Item, Item>> immediate_overlapped_items;
	if (!bin.get_bin_feasibility())
	{
		immediate_overlapped_items = bin.get_immediate_overlapped_items();
		if (immediate_overlapped_items.empty()) bin.set_bin_feasibility(true);
	}
	if (!bin.get_bin_feasibility())
	{
		uniform_int_distribution<> dis(0, static_cast<int>(immediate_overlapped_items.size()) - 1);
		int index = dis(gen);
		first_item_id = immediate_overlapped_items[index].first.get_id();
		int second_item_id = immediate_overlapped_items[index].second.get_id();
		Item first_item = bin.find_item_by_value(first_item_id);
		Item second_item = bin.find_item_by_value(second_item_id);
		//if (second_item < first_item) swap(first_item, second_item);
		first_item_id = first_item.get_id();
	}
	else
	{
		uniform_int_distribution<> dis(0, static_cast<int>(bin_items.size()) - 1);
		int position = dis(gen);
		auto it = bin_items.begin();
		advance(it, position);
		first_item_id = it->second.get_id();
	}
	return first_item_id;
}
