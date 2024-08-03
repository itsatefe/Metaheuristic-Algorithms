#ifndef UTLITY_H
#define UTILITY_H
#include <string>
#include "BinPacking.h"
#include <unordered_map>
#include <any>
using namespace std;

class Utility
{
public:
	vector<vector<Item>> read_output(string file_path, BinPacking binPacking);
	void write_output(string file_path, BinPacking binPacking);
	bool output_check_feasibility(vector<vector<Item>> output_bins, BinPacking binPacking);
	unordered_map<string, any> read_config(string file_path);
	void visualize_bins(string folder_path, BinPacking binPacking);
	void plot_objectives(string folder_path, vector<double> objectives);
	void plot_temperatures(string folder_path, vector<double> temperatures);
	void plot_differences(string folder_path, vector<double> differences);
	vector<string> read_instanceSetName(const std::string& folder_path);
	bool create_directory_if_not_exists(const string& folder_path);
	vector<string> read_excel();
	void write_excel_bins(vector<int> bins_size);
	void write_excel_time(vector<int> execution_times);
	void write_tweak_probabilities(string file_path, vector<vector<double>> data);
	void plot_results(string file_path, vector<string> datasets_name);
	void plot_tabuTenures(const string string, const vector<int> vector);
	void plot_histogram(const string& string, const vector<int>& vector);
};
#endif


