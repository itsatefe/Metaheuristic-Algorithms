#include <iostream>
#include "Genetic.h"
#include "Utility.h"
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <stdexcept>
#include <unordered_map>
#include "Types.h"
#include <any>

string instance_path = "InstanceSets/InstanceSet1/";
string instance_name = "5- random_generated_02";
string plot_folder = "Plots/";
string config_path = "Config/GA_config.txt";


struct Main_Result
{
	int bin_count;
	int execution_time;
};

Main_Result execute_algorithm(const string& dataset, unordered_map<string, any> CONFIG, int best_num_bin);

//int main()
//{
//	try
//	{
//		const unordered_map<string, any> CONFIG = Utility::read_config(config_path);
//		cout << "- instance_name: " << instance_name << '\n';
//		const Main_Result entry = execute_algorithm(instance_name, CONFIG);
//		cout << "execution time: " << entry.execution_time << '\n';
//	}
//	catch (const std::runtime_error& e)
//	{
//		std::cout << "Error: " << e.what() << '\n';
//		return 1;
//	}
//	return 0;
//}
//

int main()
{
	try
	{

		const unordered_map<string, any> CONFIG = Utility::read_config(config_path);
		string folder_path = "InstanceSet1";
		const vector<string> datasets = Utility::read_excel();
		vector<int> best_solutions = Utility::read_best_solution();

		for (int i = 0; i < 1; i++)
		{
			int j = 0;
			vector<int> bins_size;
			vector<int> execution_times;
			for (const string& dataset : datasets)
			{

				cout << "dataset name: " << dataset << '\n';
				Main_Result res = execute_algorithm(dataset, CONFIG, best_solutions[j]);
				cout << "execution_time: " << res.execution_time << '\n';
				cout << "-------------------------------" << '\n';
				bins_size.push_back(res.bin_count);
				execution_times.push_back(res.execution_time);
				j++;
			}

			Utility::write_excel_bins(bins_size);
			Utility::write_excel_time(execution_times);
			cout << datasets.size() << '\n';
			cout << " -------------------------------------------------------- run number: " << i + 1 << '\n';
		}
		//system("Python variance.py");
	}
	catch (const std::runtime_error& e)
	{
		std::cout << "Error: " << e.what() << '\n';
		return 1;
	}
	return 0;
}


Main_Result execute_algorithm(const string& dataset, unordered_map<string, any> CONFIG, int best_num_bin)
{
	instance_name = dataset;
	const INSTANCE_RESULT ins_result = Utility::read_items(instance_path + instance_name);
	SurvivalType survivalType = elitism;
	switch (any_cast<int>(CONFIG["survivalType"]))
	{
	case 0:
		survivalType = elitism;
		break;
	case 1:
		survivalType = generational;
		break;
	default:
		survivalType = elitism;
	}

	StopType stopType = timeLimit;
	switch (any_cast<int>(CONFIG["stopType"]))
	{
	case 0:
		stopType = timeLimit;
		break;
	case 1:
		stopType = generation;
		break;
	case 2:
		stopType = convergence;
		break;
	case 3:
		stopType = evalCount;
		break;
	default:
		stopType = timeLimit;
	}

	Genetic ga(ins_result.items,
		any_cast<int>(CONFIG["z"]),
		any_cast<double>(CONFIG["epsilon"]),
		any_cast<int>(CONFIG["population_size"]),
		any_cast<double>(CONFIG["init_infeasibility"]),
		any_cast<double>(CONFIG["mutation_probability"]),
		any_cast<double>(CONFIG["crossover_probability"]),
		any_cast<double>(CONFIG["convergence_threshold"]),
		any_cast<double>(CONFIG["elite_percentage"]),
		any_cast<int>(CONFIG["tournament_size"]),
		any_cast<int>(CONFIG["max_generation"]),
		any_cast<int>(CONFIG["time_limit"]),
		any_cast<int>(CONFIG["no_improvement_threshold"]),
		any_cast<int>(CONFIG["eval_limit"]),
		survivalType,
		stopType,
		ins_result.bin_width,
		ins_result.bin_height, 
		any_cast<bool>(CONFIG["memetic"]),
		best_num_bin);

	ga.algorithm();
	Chromosome best_solution = ga.get_best_solution();
	int bins_count = static_cast<int>(ga.get_best_solution().get_groups().size());

	cout << "- objectives: " << best_solution.get_fitness() << '\n';
	cout << "- bins: " << bins_count << '\n';
	bool dir_ok = Utility::create_directory_if_not_exists(plot_folder + instance_name);
	if (dir_ok)
	{
		Utility::write_tweak_probabilities(plot_folder + instance_name, ga.tweak_probabilities);
		Utility::plot_feasibility(ga.number_infeasible, ga.number_feasible, plot_folder + instance_name);
		Utility::plot_avg_objectives(ga.all_objectives,
			plot_folder + instance_name);
		Utility::visualize_bins(best_solution.get_bin_version(), plot_folder + instance_name, 0);
		Utility::plot_best_objectives(ga.best_objectives, plot_folder + instance_name);
	}

	return { bins_count, ga.execution_time };
}
