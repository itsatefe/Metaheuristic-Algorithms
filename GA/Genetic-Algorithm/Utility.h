#ifndef UTILITY_H
#define UTILITY_H
#include <any>
#include <string>
#include <unordered_map>
#include <vector>

#include "Bin.h"
#include "Item.h"

using namespace std;
struct INSTANCE_RESULT
{
	int bin_width;
	int bin_height;
	vector<Item> items;
};
class Utility
{
public:
	static void plot_feasibility(const vector<int>& number_infeasible, const vector<int>& number_feasible, const string& file_path);
	static void write_tweak_probabilities(const string& file_path, const vector<vector<double>>& tweak_probabilities);

	static INSTANCE_RESULT read_items(const string& file_path);
	static unordered_map<string, any> read_config(const string& folder_path);
	static vector<string> read_excel();
	static void write_excel_bins(const vector<int>& bins_size);
	static void write_excel_time(vector<int> execution_times);
	static vector<int> read_best_solution();
	static bool create_directory_if_not_exists(const string& folder_path);
	static void visualize_bins(vector<Bin> bins, const string& folder_path, int i);

	bool check_feasibility(string file_path);
	static void plot_best_objectives(const vector<double>& best_objectives, const string& file_path);
	static void plot_avg_objectives(const vector<double>& avg_objectives, const string& file_path);
};

#endif
