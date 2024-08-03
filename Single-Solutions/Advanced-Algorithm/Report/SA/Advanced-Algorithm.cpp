#include <iostream>
#include <fstream>
#include <vector>
#include <string> 
#include <stdexcept>
#include "BinPacking.h"
#include "SimulatedAnnealing.h"
#include "Item.h"
#include "Utility.h"
#include <unordered_map>
#include "matplotlibcpp.h"
#include "Types.h"
#include <any>

using namespace std;

string CONFIG_PATH = "Config/SA_config.txt";

BinPacking readFromFile(string file_path, unordered_map<string, any> CONFIG);
int execute_algorithm(string dataset, unordered_map<string, any> CONFIG);

int main() {
	try {
		Utility utility;
		const unordered_map<string, any> CONFIG = utility.read_config(CONFIG_PATH);
		const string dataset = "5- csAA250_16";
		const int bin_count = execute_algorithm(dataset, CONFIG);
		cout << "number of bin: " << bin_count  << '\n';
	}
	catch (const std::runtime_error& e) {
		std::cout << "Error: " << e.what() << '\n';
		return 1;
	}
	return 0;
}

//
//int main() {
//	try {
//
//		vector<int> bins_size;
//		Utility utility;
//		unordered_map<string, any> CONFIG = utility.read_config(CONFIG_PATH);
//
//		string folder_path = "InstanceSet1";
//		vector<string> datasets = utility.read_excel();
//
//		for (int i = 0; i<1;i++)
//		{
//			vector<int> bins_size;
//
//			for (const string& dataset : datasets)
//			{
//				cout << "dataset name: " << dataset << '\n';
//				int bin_count = execute_algorithm(dataset, CONFIG);
//				cout << "-------------------------------" << '\n';
//				bins_size.push_back(bin_count);
//			}
//
//			utility.write_excel(bins_size);
//			cout << datasets.size() << '\n';
//			cout << "run number: " << i+1 << '\n';
//		}
//		system("Python variance.py");
//	}
//	catch (const std::runtime_error& e) {
//		std::cout << "Error: " << e.what() << '\n';
//		return 1;
//	}
//	return 0;
//}
//
int execute_algorithm(string dataset, unordered_map<string, any> CONFIG) {
	Utility utility;
	string INSTANCE_PATH = "InstanceSets/InstanceSet1/" + dataset + ".txt";
	string OUTPUT_PATH = "Output/SA/InstanceSet1/" + dataset + "_output.txt";
	BinPacking binPacking = readFromFile(INSTANCE_PATH,CONFIG);
	ScheduleType schedule;
	switch (any_cast<int>(CONFIG["schedule"]))
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

	
	binPacking.random_bins_init();

	int min_bins = binPacking.getTotal_weight() / binPacking.getBins_capacity();
	//binPacking.displayBins();
	bool random_feasible = binPacking.check_feasibility();
	cout << boolalpha;
	cout << " random feasible: " << random_feasible << '\n';
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

	SimulatedAnnealing sa(
		binPacking,
		schedule,
		any_cast<int>(CONFIG["no_improvement_threshold"]),
		any_cast<double>(CONFIG["temperature_threshold"]),
		any_cast<double>(CONFIG["acceptance_rate"]),
		stopType,
		any_cast<double>(CONFIG["convergence_threshold"]),
		any_cast<int>(CONFIG["no_overall_improvement_threshold"]),
		any_cast<int>(CONFIG["time_limit"])
	);

	sa.algorithm();
	BinPacking solution = sa.getBest_solution();
	utility.write_output(OUTPUT_PATH, solution);
	vector<vector<Item>> output_bins = utility.read_output(OUTPUT_PATH, solution);
	bool feasible = utility.output_check_feasibility(output_bins, solution);
	cout << "- objective: " << solution.objective_function() << endl;

	cout << boolalpha;
	cout << "feasible: " << feasible << '\n';
	cout << "distance from best solution: " << solution.getBins().size() - min_bins << '\n';
	string folder_path = "Plots/SA/" + dataset;
	bool dir_ok = utility.create_directory_if_not_exists(folder_path);
	vector<double> objectives = sa.get_objectives();
	vector<double> temperatures = sa.get_temperatures();
	vector<double> differences = sa.get_differences();
	vector <vector<double>> tweak_probabilities = sa.getTweak_probabilities();

	if (dir_ok)
	{
		//utility.visualize_bins(folder_path, solution);
		utility.plot_objectives(folder_path, objectives);
		utility.plot_temperatures(folder_path, temperatures);
		utility.plot_differences(folder_path, differences);
		utility.write_tweak_probabilities(folder_path+ "/"+ dataset + ".txt", tweak_probabilities);
	}
	cout << "Evaluation Count: " << sa.EvalCount << '\n';
	return solution.getBins().size();
}



BinPacking readFromFile(string file_path, unordered_map<string, any> CONFIG) {
	string line;
	ifstream myFile(file_path);

	if (!myFile.is_open()) {
		throw runtime_error("Unable to open file: " + file_path);
	}

	int itemCount, bins_capacity;
	if (!(getline(myFile, line))) {
		throw runtime_error("File format error: missing item count in file: " + file_path);
	}
	itemCount = stoi(line);

	if (!(getline(myFile, line))) {
		throw runtime_error("File format error: missing bin capacity in file: " + file_path);
	}
	bins_capacity = stoi(line);

	unordered_map<int, Item> items;
	int weight;
	for (int id = 1; id <= itemCount && getline(myFile, line); ++id) {
		weight = stoi(line);
		Item item(id, weight);
		items[id] = item;
	}

	myFile.close();
	BinPacking binPacking(items, bins_capacity, any_cast<int>(CONFIG["max_iteration"]), any_cast<int>(CONFIG["z"]));
	return binPacking;
}
