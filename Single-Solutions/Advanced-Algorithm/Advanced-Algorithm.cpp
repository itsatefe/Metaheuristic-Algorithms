#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <stdexcept>
#include "BinPacking.h"
#include "Item.h"
#include "Utility.h"
#include <unordered_map>
#include "matplotlibcpp.h"
#include "Types.h"
#include <any>
#include "GRASP.h"

using namespace std;

struct Main_Result
{
	int bin_count;
	int execution_time;
};

struct First_Result
{
	BinPacking binPacking;
	vector<int> weights;
};


string CONFIG_PATH = "Config/GRASP_config.txt";

First_Result readFromFile(const string& file_path, unordered_map<string, any> CONFIG);
Main_Result execute_algorithm(const string& dataset, unordered_map<string, any> CONFIG);

int main() {
	try {
		Utility utility;
		const unordered_map<string, any> CONFIG = utility.read_config(CONFIG_PATH);
		const string dataset = "test_instance_4";
		const Main_Result entry = execute_algorithm(dataset, CONFIG);
		cout << "execution time: " << entry.execution_time << '\n';
	}
	catch (const std::runtime_error& e) {
		std::cout << "Error: " << e.what() << '\n';
		return 1;
	}
	return 0;
}

//int main()
//{
//	try
//	{
//		Utility utility;
//		const unordered_map<string, any> CONFIG = utility.read_config(CONFIG_PATH);
//
//		string folder_path = "InstanceSet1";
//		const vector<string> datasets = utility.read_excel();
//
//		for (int i = 0; i < 1; i++)
//		{
//			vector<int> bins_size;
//			vector<int> execution_times;
//
//			for (const string& dataset : datasets)
//			{
//				cout << "dataset name: " << dataset << '\n';
//				Main_Result res = execute_algorithm(dataset, CONFIG);
//				cout << "execution_time: " << res.execution_time << '\n';
//				cout << "-------------------------------" << '\n';
//				bins_size.push_back(res.bin_count);
//				execution_times.push_back(res.execution_time);
//			}
//
//			utility.write_excel_bins(bins_size);
//			utility.write_excel_time(execution_times);
//			cout << datasets.size() << '\n';
//			cout << "run number: " << i + 1 << '\n';
//		}
//		system("Python variance.py");
//	}
//	catch (const std::runtime_error& e)
//	{
//		std::cout << "Error: " << e.what() << '\n';
//		return 1;
//	}
//	return 0;
//}

Main_Result execute_algorithm(const string& dataset, unordered_map<string, any> CONFIG)
{
	Utility utility;
	string INSTANCE_PATH = "InstanceSets/InstanceSet1/" + dataset + ".txt";
	string OUTPUT_PATH = "Output/GRASP/InstanceSet1/" + dataset + "_output.txt";
	First_Result first_result = readFromFile(INSTANCE_PATH, CONFIG);

	BinPacking binPacking = first_result.binPacking;
	//binPacking.random_bins_init();

	int min_bins = binPacking.getTotal_weight() / binPacking.getBins_capacity();
	//first_binPacking.displayBins();
	bool random_feasible = binPacking.check_feasibility();
	cout << boolalpha;
	cout << "- random feasible: " << random_feasible << '\n';
	cout << "- objective: " << binPacking.objective_function() << '\n';
	StopType stopType = mix;
	switch (any_cast<int>(CONFIG["stopType"]))
	{
	case 0:
		stopType = timeLimit;
		break;
	case 1:
		stopType = iteration;
		break;
	case 2:
		stopType = convergence;
		break;
	case 3:
		stopType = mix;
		break;
	default:
		stopType = mix;
	}

	LocalSearch localSearch = Hill_Climbing;
	switch (any_cast<int>(CONFIG["localSearch"]))
	{
	case 0:
		localSearch = Hill_Climbing;
		break;
	case 1:
		localSearch = Tabu_Search;
		break;
	case 2:
		localSearch = Simulated_Annealing;
		break;
	default:
		localSearch = Hill_Climbing;
	}


	GRASP grasp(binPacking,
		localSearch,
		stopType,
		any_cast<double>(CONFIG["heuristic_probability"]),
		any_cast<double>(CONFIG["alpha"]),
		any_cast<int>(CONFIG["no_improvement_threshold"]),
		any_cast<int>(CONFIG["time_limit"]));

	grasp.algorithm();
	BinPacking solution = grasp.getBest_solution();
	utility.write_output(OUTPUT_PATH, solution);
	vector<vector<Item>> output_bins = utility.read_output(OUTPUT_PATH, solution);
	bool feasible = utility.output_check_feasibility(output_bins, solution);
	cout << "- objective: " << solution.objective_function() << '\n';
	cout << boolalpha;
	cout << "feasible: " << feasible << '\n';
	cout << "Min Bins: " << min_bins << '\n';
	cout << "Bin Size: " << solution.getBins().size() << '\n';
	cout << "Evaluation Count: " << grasp.eval_Count << '\n';

	string folder_path = "Plots/GRASP/" + dataset;
	//utility.plot_histogram(folder_path, first_result.weights);

	bool dir_ok = utility.create_directory_if_not_exists(folder_path);
	vector<double> objectives = grasp.get_objectives();
	vector<double> temperatures = grasp.get_temperatures();
	//vector<int> tabu_tenures = grasp.get_tabuTenures();
	vector<vector<double>> tweak_probabilities = grasp.getTweak_probabilities();


	if (dir_ok)
	{
		//utility.visualize_bins(folder_path, solution);
		utility.plot_objectives(folder_path, objectives);
		//utility.plot_tabuTenures(folder_path, tabu_tenures);
		utility.write_tweak_probabilities(folder_path + "/" + dataset + ".txt", tweak_probabilities);
		if (!temperatures.empty()) utility.plot_temperatures(folder_path, temperatures);
	}
	return { static_cast<int>(solution.getBins().size()), grasp.get_execution_time() };
}


First_Result readFromFile(const string& file_path, unordered_map<string, any> CONFIG) {
	ifstream myFile(file_path);
	if (!myFile.is_open()) {
		throw runtime_error("Unable to open file: " + file_path);
	}

	// Read the entire file into a single string
	ostringstream ss;
	ss << myFile.rdbuf();
	string fileContents = ss.str();
	myFile.close();

	// Use a string stream to process the file line by line
	istringstream iss(fileContents);
	string line;

	// Read item count
	if (!getline(iss, line)) {
		throw runtime_error("File format error: missing item count in file: " + file_path);
	}
	int itemCount = stoi(line);

	// Read bins capacity
	if (!getline(iss, line)) {
		throw runtime_error("File format error: missing bin capacity in file: " + file_path);
	}
	int bins_capacity = stoi(line);

	// Process items
	unordered_map<int, Item> items;
	vector<int> weights;
	vector<int> items_id;
	int weight;
	for (int id = 1; id <= itemCount && getline(iss, line); ++id) {
		weight = stoi(line);
		items_id.push_back(id);
		Item item(id, weight);
		items[id] = item;
		weights.push_back(weight);
	}

	// Initialize and return results
	BinPacking binPacking(items, bins_capacity, any_cast<int>(CONFIG["max_iteration"]), any_cast<int>(CONFIG["z"]));
	binPacking.set_items_id(items_id);

	return { binPacking, weights };
}