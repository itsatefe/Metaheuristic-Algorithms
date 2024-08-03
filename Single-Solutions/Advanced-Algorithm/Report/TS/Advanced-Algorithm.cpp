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

#include "TabuSearch.h"

using namespace std;

struct Main_Result {
	int bin_count;
	int execution_time;

};
string CONFIG_PATH = "Config/TS_config.txt";

BinPacking readFromFile(string file_path, unordered_map<string, any> CONFIG);
Main_Result execute_algorithm(string dataset, unordered_map<string, any> CONFIG);

//int main() {
//	try {
//		Utility utility;
//		const unordered_map<string, any> CONFIG = utility.read_config(CONFIG_PATH);
//		const string dataset = "5- csAA250_16";
//		const Main_Result entry = execute_algorithm(dataset, CONFIG);
//	}
//	catch (const std::runtime_error& e) {
//		std::cout << "Error: " << e.what() << '\n';
//		return 1;
//	}
//	return 0;
//}

int main() {
	try {

		Utility utility;
		unordered_map<string, any> CONFIG = utility.read_config(CONFIG_PATH);

		string folder_path = "InstanceSet1";
		vector<string> datasets = utility.read_excel();

		for (int i = 0; i<1;i++)
		{
			vector<int> bins_size;
			vector<int> execution_times;

			for (const string& dataset : datasets)
			{
				cout << "dataset name: " << dataset << '\n';
				Main_Result res = execute_algorithm(dataset, CONFIG);
				cout << "-------------------------------" << '\n';
				bins_size.push_back(res.bin_count);
				execution_times.push_back(res.execution_time);
			}

			utility.write_excel_bins(bins_size);
			utility.write_excel_time(execution_times);
			cout << datasets.size() << '\n';
			cout << "run number: " << i+1 << '\n';
		}
		system("Python variance.py");
	}
	catch (const std::runtime_error& e) {
		std::cout << "Error: " << e.what() << '\n';
		return 1;
	}
	return 0;
}

Main_Result execute_algorithm(string dataset, unordered_map<string, any> CONFIG) {
	Utility utility;
	string INSTANCE_PATH = "InstanceSets/InstanceSet1/" + dataset + ".txt";
	string OUTPUT_PATH = "Output/TS/InstanceSet1/" + dataset + "_output.txt";
	BinPacking binPacking = readFromFile(INSTANCE_PATH,CONFIG);
	
	
	binPacking.random_bins_init();

	int min_bins = binPacking.getTotal_weight() / binPacking.getBins_capacity();
	//first_binPacking.displayBins();
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

	TabuSearch ts(binPacking,
		any_cast<int>(CONFIG["no_improvement_threshold"]),
		stopType,
		any_cast<double>(CONFIG["convergence_threshold"]),
		any_cast<int>(CONFIG["time_limit"]),
		any_cast<int>(CONFIG["tabuSize"]),
		any_cast<int>(CONFIG["tweaksCount"])
	);

	ts.algorithm();
	BinPacking solution = ts.getBest_solution();
	utility.write_output(OUTPUT_PATH, solution);
	vector<vector<Item>> output_bins = utility.read_output(OUTPUT_PATH, solution);
	bool feasible = utility.output_check_feasibility(output_bins, solution);
	cout << "- objective: " << solution.objective_function() << '\n';
	cout << boolalpha;
	cout << "feasible: " << feasible << '\n';
	cout << "Min Bins: " << min_bins << '\n';
	cout << "Bin Size: " << solution.getBins().size() << '\n';
	cout << "Evaluation Count: " << ts.eval_Count << '\n';

	string folder_path = "Plots/TS/" + dataset;
	bool dir_ok = utility.create_directory_if_not_exists(folder_path);
	vector<double> objectives = ts.get_objectives();
	vector<int> tabu_tenures = ts.get_tabuTenures();
	vector <vector<double>> tweak_probabilities = ts.getTweak_probabilities();


	if (dir_ok)
	{
		//utility.visualize_bins(folder_path, solution);
		utility.plot_objectives(folder_path, objectives);
		utility.plot_tabuTenures(folder_path, tabu_tenures);
		utility.write_tweak_probabilities(folder_path+ "/"+ dataset + ".txt", tweak_probabilities);
	}
	return { static_cast<int>(solution.getBins().size()) , ts.get_execution_time()};
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
