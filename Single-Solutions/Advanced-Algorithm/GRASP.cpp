#include "GRASP.h"
#include <algorithm>
#include <random>
#include "HillClimbing.h"
#include "SimulatedAnnealing.h"
#include "TabuSearch.h"
#include "Types.h"
#include "Utility.h"

using namespace std;

unordered_map<string, any> read_localConfig(LocalSearch localSearch)
{
	Utility utility;
	string CONFIG_PATH;

	switch (localSearch)
	{
	case Hill_Climbing:
		CONFIG_PATH = "Config/HC_config.txt";
		break;
	case Tabu_Search:
		CONFIG_PATH = "Config/TS_config.txt";

		break;
	case Simulated_Annealing:
		CONFIG_PATH = "Config/SA_config.txt";
		break;
	}
	return utility.read_config(CONFIG_PATH);
}

GRASP::GRASP(BinPacking& binPacking, LocalSearch localSearch, StopType stopType,
	double heuristic_probability, double alpha, int no_improvement_threshold,
	int time_limit) : best_binPacking(binPacking), first_binPacking(binPacking)
{
	this->no_improvement_threshold = no_improvement_threshold;
	this->no_improvement_count = 0;
	this->max_bin_id = -1;
	this->alpha_adjust_count = 0;
	this->eval_Count = 1;
	this->execution_time = 0;
	this->current_iteration = 1;
	this->loop_duration = chrono::seconds(time_limit);
	this->local_CONFIG = read_localConfig(localSearch);
	this->stopType = stopType;
	this->localSearch = localSearch;
	this->alpha = alpha;
	this->heuristic_probability = heuristic_probability;
	this->local_time = 0;
}


void GRASP::adapt_parameters(int count)
{
	if (count >= 6)
	{
		cout << "- alpha: " << alpha << '\n';
		alpha += 0.1;
	}
}

int calculate_new_bin_id(unordered_map<int, Bin> bins)
{
	const int bins_size = bins.size();
	vector<int> bin_indices(bins_size);
	int bin_index = 0;
	for (auto& bin : bins)
	{
		bin_indices[bin_index] = bin.first;
		bin_index++;
	}
	if (bins_size > 0)
	{
		int max_id = *max_element(bin_indices.begin(), bin_indices.end());
		return (max_id + 1);
	}
	return 0;
}

unordered_map<int, Item> GRASP::shuffle_items()
{
	std::unordered_map<int, Item> items = first_binPacking.getItems();

	std::vector<std::pair<int, Item>> itemsVector(items.begin(), items.end());

	// Shuffle the vector
	auto rng = std::default_random_engine{};
	rng.seed(std::chrono::system_clock::now().time_since_epoch().count()); // seed with current time
	std::shuffle(std::begin(itemsVector), std::end(itemsVector), rng);

	std::unordered_map<int, Item> shuffledItems;
	for (auto& item : itemsVector)
	{
		shuffledItems[item.first] = item.second;
	}
	return shuffledItems;
}


BinPacking GRASP::construction_phase()
{
	max_bin_id = -1;
	unordered_map<int, Item> remaining_items = first_binPacking.getItems();
	//unordered_map<int, Item> items = shuffle_items();
	unordered_map<int, Item> items = first_binPacking.getItems();
	unordered_map<int, Bin> bins;

	std::random_device rd;
	std::mt19937 gen(rd());
	//calculate_alpha();
	double calc_alpha = alpha;
	int i = 0;
	for (auto& [id, item] : items)
	{
		i++;
		if (i % 500 == 0)
			cout << "iteration: " << i << '\n';
		vector<Bin> rcl = RCL_maker(bins, item, calc_alpha);
		std::uniform_int_distribution<> dist(0, rcl.size() - 1);
		const int random_bin_index = dist(gen);
		Bin bin = rcl[random_bin_index];
		int bestBinId = bin.getId();
		item.setBin_id(bestBinId);
		auto it = bins.find(bestBinId);
		if (it != bins.end())
		{
			bins[bestBinId].addToBin(item);
		}
		else
		{
			Bin new_bin(bestBinId, first_binPacking.getBins_capacity());
			new_bin.addToBin(item);
			bins[bestBinId] = new_bin;
		}
		remaining_items.erase(item.getId());
	}

	BinPacking new_binPacking(items, first_binPacking.getBins_capacity(), first_binPacking.getMax_iteration(),
		first_binPacking.get_z());
	new_binPacking.set_bins(bins);
	new_binPacking.objective_function();
	new_binPacking.set_items_id(first_binPacking.get_items_id());

	eval_Count++;
	cout << "initial size: " << new_binPacking.getBins().size() << '\n';
	return new_binPacking;
}

vector<Bin> GRASP::RCL_maker(unordered_map<int, Bin> bins, Item item, double calc_alpha)
{
	random_device rd;
	mt19937 gen(rd());
	uniform_real_distribution<> dis(0, 1);
	const double random_double = dis(gen);

	if (random_double > heuristic_probability)
	{
		/*auto rng = std::default_random_engine{};
		rng.seed(std::chrono::system_clock::now().time_since_epoch().count());
		std::shuffle(std::begin(bins), std::end(bins), rng);*/
		vector<Bin> rcl = first_fit(bins, item);
		rcl.resize(min(5, static_cast<const int&>(ceil((1 - alpha) * rcl.size()))));

		//cout << "rcl size: " << rcl.size() << '\n';
		return rcl;
	}
	vector<Bin> rcl = best_fit(bins, item);
	//rcl.resize(ceil((alpha)*rcl.size()));
	rcl.resize(min(5, static_cast<const int&>(ceil((1 - alpha) * rcl.size()))));


	//cout << "rcl size: " << rcl.size() << '\n';

	return rcl;
}

void GRASP::calculate_alpha()
{
	if (double fraction = static_cast<double>(alpha_adjust_count) / no_improvement_threshold; fraction <= 1 &&
		alpha_adjust_count < 4)
	{
		alpha -= 0.1;
		alpha_adjust_count++;
		local_time = 5 * (1 + alpha);
		cout << "Adjusted alpha: " << alpha << '\n';
	}
}


vector<Bin> selectCandidateBins(const unordered_map<int, Bin>& bins, const Item& item, int start_index) {
	vector<Bin> candidates;
	auto it = bins.begin();
	std::advance(it, start_index);
	for (int count = 0; it != bins.end() && count < 5; ++it, ++count) {
		if (it->second.getCapacity() >= item.getWeight()) {
			candidates.push_back(it->second);
		}
	}
	return candidates;
}

Bin GRASP::createNewBin() {
	return { ++max_bin_id, first_binPacking.getBins_capacity() };
}

vector<Bin> GRASP::best_fit(const unordered_map<int, Bin>& bins, const Item& item) {
	random_device rd;
	mt19937 gen(rd());
	int bins_size = bins.size();

	if (bins_size == 0) {
		return { createNewBin() };
	}

	uniform_int_distribution<> dis(0, bins_size - 1);
	int selected_bin_index = dis(gen);

	vector<Bin> candidate_list = selectCandidateBins(bins, item, selected_bin_index);

	// Wrap around logic if needed
	if (candidate_list.size() < 5 && selected_bin_index > 0) {
		vector<Bin> more_candidates = selectCandidateBins(bins, item, 0);
		candidate_list.insert(candidate_list.end(), more_candidates.begin(), more_candidates.end());
		if (candidate_list.size() > 5) {
			candidate_list.resize(5);
		}
	}

	if (candidate_list.empty()) {
		candidate_list.push_back(createNewBin());
	}

	// Sorting based on remaining capacity could be another approach
	std::sort(candidate_list.begin(), candidate_list.end(), [](const Bin& a, const Bin& b) {
		return a.getCapacity() < b.getCapacity();
		});

	return candidate_list;
}

//vector<Bin> GRASP::best_fit(unordered_map<int, Bin> bins, Item item)
//{
//	random_device rd;
//	mt19937 gen(rd());
//	const int bins_size = bins.size();
//	vector<Bin> candidate_list;
//
//	if (bins_size == 0)
//	{
//		//constexpr int new_id = 0;
//		const Bin new_bin(++max_bin_id, first_binPacking.getBins_capacity());
//		candidate_list.push_back(new_bin);
//		return candidate_list;
//	}
//	uniform_int_distribution<> dis(0, bins_size - 1);
//	const int selected_bin_index = dis(gen);
//	vector<int> bin_indices(bins_size);
//	int bin_index = 0;
//	for (auto& bin : bins)
//	{
//		bin_indices[bin_index] = bin.first;
//		bin_index++;
//	}
//	int bestBinId = -1;
//	int min_capacity = first_binPacking.getBins_capacity();
//
//	for (int i = selected_bin_index; i < bins_size; i++)
//	{
//		const int selected_bin_id = bin_indices[i];
//		Bin& bin = bins[selected_bin_id];
//		const int remain_capacity = bin.getCapacity() - item.getWeight();
//		if (remain_capacity < 0) continue;
//		candidate_list.push_back(bin);
//		if (candidate_list.size() >= 5)
//			break;
//	}
//
//	// another approach: search from the first part of bins to selected bin index
//
//	if (candidate_list.empty())
//	{
//		Bin new_bin(++max_bin_id, first_binPacking.getBins_capacity());
//		candidate_list.push_back(new_bin);
//	}
//
//	ranges::sort(candidate_list, [](const auto& a, const auto& b) { return a.getCapacity() < b.getCapacity(); });
//	return candidate_list;
//}

vector<Bin> GRASP::first_fit(unordered_map<int, Bin> bins, Item item)
{
	vector<Bin> candidate_list;
	int i = 0;
	for (auto [id, bin] : bins)
	{
		if (bin.getCapacity() >= item.getWeight())
		{
			candidate_list.push_back(bin);
		}

		if (candidate_list.size() >= 5)
		{
			break;
		}
		i++;
	}
	cout << "first fit: " << i << '\n';
	if (candidate_list.empty())
	{
		//int new_id = calculate_new_bin_id(bins);
		//int new_id = GRASP::getNextBinId();

		Bin new_bin(++max_bin_id, first_binPacking.getBins_capacity());
		candidate_list.push_back(new_bin);
	}
	return candidate_list;
}

Bin& random_bin(unordered_map<int, Bin>& bins)
{
	random_device rd;
	mt19937 gen(rd());
	const int bins_size = bins.size();
	uniform_int_distribution<> dis(0, bins_size - 1);
	const int selected_bin_index = dis(gen);
	vector<int> bin_indices(bins_size);
	int bin_index = 0;
	for (auto& bin : bins)
	{
		bin_indices[bin_index] = bin.first;
		bin_index++;
	}
	const int selected_bin_id = bin_indices[selected_bin_index];
	return bins[selected_bin_id];
}

Local_Result GRASP::local_search(BinPacking current_binPacking)
{
	switch (localSearch)
	{
	case Hill_Climbing:
		return HC_phase(current_binPacking);
		break;
	case Tabu_Search:
		return TS_phase(current_binPacking);
		break;
	case Simulated_Annealing:
		return SA_phase(current_binPacking);
		break;
	default:
		return HC_phase(current_binPacking);
	}
}

StopType getStopType_local(int stopType)
{
	StopType stopType_local = mix;
	switch (stopType)
	{
	case 0:
		stopType_local = timeLimit;
		break;
	case 1:
		stopType_local = iteration;
		break;
	case 2:
		stopType_local = convergence;
		break;
	case 3:
		stopType_local = mix;
		break;
	default:
		stopType_local = mix;
	}
	return stopType_local;
}

Local_Result GRASP::HC_phase(BinPacking current_binPacking)
{
	HillClimbing hc(current_binPacking, any_cast<int>(local_CONFIG["no_improvement_threshold"]),
		getStopType_local(any_cast<int>(local_CONFIG["stopType"])),
		any_cast<int>(local_CONFIG["tweaksCount"]), any_cast<int>(local_CONFIG["time_limit"]));
	hc.algorithm();
	eval_Count += hc.eval_Count;

	for (auto objective : hc.get_objectives())
	{
		objectives.push_back(objective);
	}
	for (const auto& tweak_probability : hc.getTweak_probabilities())
	{
		tweak_probabilities.push_back(tweak_probability);
	}
	current_iteration += hc.current_iteration;
	return { hc.getBest_solution(), hc.get_execution_time() };
}

Local_Result GRASP::TS_phase(BinPacking current_binPacking)
{
	TabuSearch ts(current_binPacking,
		any_cast<int>(local_CONFIG["no_improvement_threshold"]),
		getStopType_local(any_cast<int>(local_CONFIG["stopType"])),
		any_cast<double>(local_CONFIG["convergence_threshold"]),
		any_cast<int>(local_CONFIG["time_limit"]),
		any_cast<int>(local_CONFIG["tabuSize"]),
		any_cast<int>(local_CONFIG["tweaksCount"]));

	ts.algorithm();

	eval_Count += ts.eval_Count;

	for (auto objective : ts.get_objectives())
	{
		objectives.push_back(objective);
	}
	for (const auto& tweak_probability : ts.getTweak_probabilities())
	{
		tweak_probabilities.push_back(tweak_probability);
	}
	current_iteration += ts.current_iteration;

	return { ts.getBest_solution(), ts.get_execution_time() };
}

Local_Result GRASP::SA_phase(BinPacking current_binPacking)
{
	ScheduleType schedule;
	switch (any_cast<int>(local_CONFIG["schedule"]))
	{
	case 0:
		schedule = linear;
		break;
	case 1:
		schedule = logarithmic;
		break;
	case 2:
		schedule = composite;
		break;
	case 3:
		schedule = square_root;
		break;
	default:
		schedule = composite;
	}
	SimulatedAnnealing sa(
		current_binPacking,
		schedule,
		any_cast<int>(local_CONFIG["no_improvement_threshold"]),
		any_cast<double>(local_CONFIG["temperature_threshold"]),
		any_cast<double>(local_CONFIG["acceptance_rate"]),
		getStopType_local(any_cast<int>(local_CONFIG["stopType"])),
		any_cast<double>(local_CONFIG["convergence_threshold"]),
		any_cast<int>(local_CONFIG["no_overall_improvement_threshold"]),
		any_cast<int>(local_CONFIG["time_limit"])
	);

	sa.algorithm();

	eval_Count += sa.eval_Count;

	for (auto objective : sa.get_objectives())
	{
		objectives.push_back(objective);
	}
	for (const auto& tweak_probability : sa.getTweak_probabilities())
	{
		tweak_probabilities.push_back(tweak_probability);
	}

	for (const auto& temperature : sa.get_temperatures())
	{
		temperatures.push_back(temperature);
	}
	current_iteration += sa.current_iteration;
	return { sa.getBest_solution(), sa.get_execution_time() };
}


void GRASP::algorithm()
{
	bool stopped = false;
	auto start = chrono::high_resolution_clock::now();
	while (!stopped)
	{
		BinPacking current_binPacking = construction_phase();
		const double current_objective = current_binPacking.get_objective();
		objectives.push_back(current_objective);

		Local_Result next_result = local_search(current_binPacking);
		//cout << "current_iteration: " << current_iteration << '\n';

		const double next_objective = next_result.binPacking.get_objective();

		if (best_binPacking.get_objective() <= next_objective)
		{
			no_improvement_count++;
		}
		else
		{
			no_improvement_count = 0;
			best_binPacking = next_result.binPacking;
			execution_time = next_result.execution_time;
		}
		stopped = stopping_condition(start, no_improvement_count);
	}
}

BinPacking GRASP::getBest_solution()
{
	return best_binPacking;
}

int GRASP::get_execution_time() const
{
	return execution_time;
}

vector<double> GRASP::get_objectives()
{
	return objectives;
}

vector<double> GRASP::get_temperatures()
{
	return temperatures;
}

vector<vector<double>> GRASP::getTweak_probabilities()
{
	return tweak_probabilities;
}

bool GRASP::stopping_condition(std::chrono::high_resolution_clock::time_point start, int count)
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
		return this->stopBy_Convergence(count, start);
		break;
	default:
		return false;
	}
}

bool GRASP::stopBy_Convergence(int count, std::chrono::high_resolution_clock::time_point start) const
{
	if (count >= no_improvement_threshold)
	{
		cout << count << ": count" << '\n';
		auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start)).
			count();
		cout << "exit time: " << stop << '\n';
		//this->execution_time = static_cast<int>(stop);
		return true;
	}

	if (const int max_iteration = first_binPacking.getMax_iteration(); current_iteration >= max_iteration)
	{
		auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start)).
			count();
		cout << "exit time: " << stop << '\n';
		//this->execution_time = static_cast<int>(stop);
		return true;
	}

	return false;
}

bool GRASP::stopBy_iteration() const
{
	if (current_iteration >= first_binPacking.getMax_iteration()) return false;
	return true;
}

bool GRASP::stopBy_time(std::chrono::high_resolution_clock::time_point start) const
{
	if (chrono::high_resolution_clock::now() - start < loop_duration)
		return false;
	auto stop = std::chrono::duration_cast<std::chrono::seconds>((chrono::high_resolution_clock::now() - start));
	/*cout << "exit time: " << stop << '\n';
	cout << "last iteration: " << current_iteration << '\n';*/
	return true;
}
