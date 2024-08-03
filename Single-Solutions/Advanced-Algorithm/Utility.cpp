#include "Utility.h"
#include "BinPacking.h"
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#include <unordered_map>
#include <iostream>
#include <stdexcept>
#include <nlohmann/json.hpp>
#include "matplotlibcpp.h"
#include <filesystem>
#include <libxl.h>
#include <cwchar>
#include <numeric>
#include <any>
#include <set>
namespace plt = matplotlibcpp;
using json = nlohmann::json;
using namespace std;
namespace fs = filesystem;
using namespace libxl;

vector<vector<Item>> Utility::read_output(string file_path, BinPacking binPacking)
{
	string line;
	ifstream myFile(file_path);
	if (!myFile.is_open())
	{
		throw runtime_error("Unable to open file: " + file_path);
	}
	int binCount;
	if (!(getline(myFile, line)))
	{
		throw runtime_error("File format error: missing item count in file: " + file_path);
	}
	binCount = stoi(line);
	unordered_map<int, Item> items = binPacking.getItems();

	vector<vector<Item>> output_bins;
	while (getline(myFile, line))
	{
		istringstream iss(line);
		vector<Item> output_items;
		string token;
		int weight = 0;
		while (getline(iss, token, ' '))
		{
			int id = stoi(token);
			output_items.push_back(items[id]);
		}
		output_bins.push_back(output_items);
	}
	myFile.close();
	return output_bins;
}

void Utility::write_output(string file_path, BinPacking binPacking)
{
	try
	{
		ofstream outputFile(file_path);
		if (!outputFile.is_open())
		{
			throw runtime_error("Error opening file for writing: " + file_path);
		}

		outputFile << binPacking.getBins().size() << '\n';
		for (auto& bin : binPacking.getBins())
		{
			vector<Item> sublist = bin.second.getBin_items();
			for (size_t i = 0; i < sublist.size(); ++i)
			{
				outputFile << sublist[i].getId();
				if (i < sublist.size() - 1) outputFile << " ";
			}
			outputFile << '\n';
		}
	}
	catch (const runtime_error& e)
	{
		cerr << "Runtime error: " << e.what() << '\n';
	}
	catch (const exception& e)
	{
		cerr << "Exception occurred: " << e.what() << '\n';
	}
	catch (...)
	{
		cerr << "An unknown error occurred.\n";
	}
}

bool Utility::output_check_feasibility(vector<vector<Item>> output_bins, BinPacking binPacking)
{
	int sum_weight = 0;
	for (auto& sublist : output_bins)
	{
		int weight = 0;
		for (auto& item : sublist)
		{
			weight += item.getWeight();
		}
		sum_weight += weight;
		if (weight > binPacking.getBins_capacity())
		{
			return false;
		}
	}

	if (sum_weight != binPacking.sumItems_weight())
	{
		return false;
	}
	return true;
}


unordered_map<string, any> Utility::read_config(string file_path)
{
	unordered_map<string, any> configMap;
	ifstream configFile(file_path);
	if (!configFile.is_open())
	{
		std::cerr << "Failed to open file: " << file_path << std::endl;
		return configMap;
	}

	json j;
	try
	{
		configFile >> j;
	}
	catch (const json::parse_error& e)
	{
		std::cerr << "JSON parsing error: " << e.what() << std::endl;
		return configMap;
	}

	for (auto it = j.begin(); it != j.end(); ++it)
	{
		if (it.value().is_number_integer())
		{
			configMap[it.key()] = it.value().get<int>();
		}
		else if (it.value().is_number_float())
		{
			configMap[it.key()] = it.value().get<double>();
		}
		else if (it.value().is_string())
		{
			configMap[it.key()] = it.value().get<string>();
		} // Add more type checks as needed
		else
		{
			std::cerr << "Unsupported type for key '" << it.key() << "'" << std::endl;
		}
	}

	return configMap;
}


void Utility::visualize_bins(string folder_path, BinPacking binPacking)
{
	int bins_per_row = 6;
	unordered_map<int, Bin> bins_items = binPacking.getBins();
	int num_bins = bins_items.size();
	int bin_capacity = binPacking.getBins_capacity();
	int num_rows = static_cast<int>(std::ceil(static_cast<double>(num_bins) / bins_per_row));

	plt::figure_size(1500, num_rows * 200);
	int i = 0;
	for (auto bin : bins_items)
	{
		plt::subplot(num_rows, bins_per_row, i + 1);

		auto items = bin.second.getBin_items();
		sort(items.begin(), items.end(), [](const Item& a, const Item& b)
			{
				return a.getWeight() < b.getWeight();
			});

		vector<Item> items_weight;
		double acc_weight = 0;
		for (Item& item : items)
		{
			double weight = item.getWeight();
			acc_weight += weight;
			Item new_item(item.getId(), acc_weight);
			new_item.setBin_id(item.getBin_id());
			items_weight.push_back(new_item);
		}

		sort(items_weight.begin(), items_weight.end(), [](const Item& a, const Item& b)
			{
				return a.getWeight() > b.getWeight();
			});

		for (int j = 0; j < items_weight.size(); j++)
		{
			double top_weight = items_weight[j].getWeight();
			double text_pos_y = top_weight / 2;
			if (j + 1 < items_weight.size())
			{
				double next_weight = items_weight[j + 1].getWeight();
				text_pos_y = ((top_weight - next_weight) / 2) + next_weight;
			}
			plt::bar(vector<double>{0.5}, vector<double>{top_weight});
			int real_weight = binPacking.getItems()[items_weight[j].getId()].getWeight();
			string text = "id: " + to_string(items_weight[j].getId()) + " - size: " + to_string(real_weight);
			plt::text(0.2, text_pos_y, text);
		}
		plt::ylim(0, bin_capacity + 1);
		plt::title(to_string(bin.second.getId()));
		plt::xticks(vector<double>{});
		i++;
	}
	plt::tight_layout();
	plt::save(folder_path + "/visualization.png");
	plt::close();
	//plt::show();
}

void Utility::plot_objectives(string folder_path, vector<double> objectives)
{
	vector<int> x_objectives(objectives.size());
	iota(x_objectives.begin(), x_objectives.end(), 0);
	plt::figure();
	plt::plot(x_objectives, objectives);
	plt::title("Objective Function Values");
	plt::xlabel("Iteration");
	plt::ylabel("Objective Value");
	plt::save(folder_path + "/objectives.png");
	plt::close();
	//plt::show();
}

void Utility::plot_temperatures(string folder_path, vector<double> temperatures)
{
	vector<int> x_temperatures(temperatures.size());
	iota(x_temperatures.begin(), x_temperatures.end(), 0);
	plt::figure();
	plt::plot(x_temperatures, temperatures);
	plt::title("Cooling Schedule");
	plt::xlabel("Iteration");
	plt::ylabel("Temperature");
	plt::save(folder_path + "/temperatures.png");
	plt::close();
	//plt::show();
}

void Utility::plot_differences(string folder_path, vector<double> differences)
{
	vector<int> x_differences(differences.size());
	iota(x_differences.begin(), x_differences.end(), 0);
	plt::figure();
	plt::plot(x_differences, differences);
	plt::title("Energy");
	plt::xlabel("Iteration");
	plt::ylabel("energy");
	plt::save(folder_path + "/differences.png");
	plt::close();
	//plt::show();
}

vector<string> Utility::read_instanceSetName(const string& folder_path)
{
	vector<string> filenames;
	for (const auto& entry : fs::directory_iterator(folder_path))
	{
		if (entry.is_regular_file())
		{
			if (entry.path().extension() == ".txt")
			{
				filenames.push_back(entry.path().stem().string());
			}
		}
	}
	return filenames;
}

bool Utility::create_directory_if_not_exists(const string& folder_path)
{
	fs::path dir(folder_path);
	if (!exists(dir))
	{
		return create_directory(dir);
	}
	return true;
}

string removeTxtExtension(const string& filename)
{
	string result = filename;
	size_t extensionPos = result.rfind(".txt");
	if (extensionPos != string::npos)
	{
		// Ensure the ".txt" is at the end of the string
		if (extensionPos + 4 == result.length())
		{
			result.erase(extensionPos);
		}
	}
	return result;
}

vector<string> Utility::read_excel()
{
	Book* book = xlCreateXMLBook();
	vector<string> dataset_names;
	if (book->load(L"best_solutions.xlsx"))
	{
		Sheet* sheet = book->getSheet(0);
		if (sheet)
		{
			for (int i = 1; i < sheet->lastRow(); ++i)
			{
				const wchar_t* datasetNeame = sheet->readStr(i, 0);
				if (datasetNeame != nullptr)
				{
					size_t convertedChars = 0;
					size_t len = wcslen(datasetNeame) * 4 + 1;
					auto buffer = new char[len];

					errno_t err = wcstombs_s(&convertedChars, buffer, len, datasetNeame, _TRUNCATE);
					if (err == 0)
					{
						string dataset(buffer);
						string file_name = removeTxtExtension(dataset);
						dataset_names.push_back(file_name);
					}
					delete[] buffer;
				}
			}
			book->release();
		}
	}
	return dataset_names;
}

void Utility::write_excel_bins(vector<int> bins_size)
{
	Book* book = xlCreateXMLBook();
	if (book->load(L"best_solutions_new.xlsx"))
	{
		Sheet* sheet = book->getSheet(0);
		if (sheet)
		{
			int newColumn = 0;

			while (sheet->readStr(1, newColumn) != nullptr)
			{
				newColumn++;
			}

			for (int row = 1; row <= bins_size.size(); ++row)
			{
				sheet->writeNum(row, newColumn, bins_size[row - 1]);
			}
			book->save(L"best_solutions_new.xlsx");
		}
	}
	book->release();
}


void Utility::write_excel_time(vector<int> execution_times)
{
	Book* book = xlCreateXMLBook();
	if (book->load(L"solutions-time.xlsx"))
	{
		Sheet* sheet = book->getSheet(0);
		if (sheet)
		{
			int newColumn = 0;

			while (sheet->readStr(1, newColumn) != nullptr)
			{
				newColumn++;
			}

			for (int row = 1; row <= execution_times.size(); ++row)
			{
				sheet->writeNum(row, newColumn, execution_times[row - 1]);
			}
			book->save(L"solutions-time.xlsx");
		}
	}
	book->release();
}


void Utility::write_tweak_probabilities(string file_path, vector<vector<double>> data)
{
	try
	{
		ofstream outputFile(file_path);
		if (!outputFile.is_open())
		{
			throw runtime_error("Error opening file for writing: " + file_path);
		}
		for (const auto& vec : data)
		{
			for (size_t i = 0; i < vec.size(); ++i)
			{
				outputFile << vec[i];
				if (i < vec.size() - 1)
				{
					outputFile << ",";
				}
			}
			outputFile << "\n";
		}

		outputFile.close();
	}
	catch (const runtime_error& e)
	{
		cerr << "Runtime error: " << e.what() << '\n';
	}
	catch (const exception& e)
	{
		cerr << "Exception occurred: " << e.what() << '\n';
	}
	catch (...)
	{
		cerr << "An unknown error occurred.\n";
	}
}


void Utility::plot_tabuTenures(const string folder_path, const vector<int> tabu_tenures)

{
	vector<int> x_tabuTenures(tabu_tenures.size());
	iota(x_tabuTenures.begin(), x_tabuTenures.end(), 0);
	plt::figure();
	plt::plot(x_tabuTenures, tabu_tenures);
	plt::title("Tabu List Size");
	plt::xlabel("Iteration");
	plt::ylabel("Tabu Tenure");
	plt::save(folder_path + "/tabuTenures.png");
	plt::close();
	//plt::show();
}

void Utility::plot_histogram(const string& folder_path, const vector<int>& weights)
{
	std::set<double> uniqueWeights(weights.begin(), weights.end());
	int numberOfBins = uniqueWeights.size();
	plt::hist(weights, numberOfBins);
	plt::title("Histogram");
	plt::xlabel("weights");
	plt::ylabel("number of items");
	plt::save(folder_path + "/histogram.png");
	plt::close();
	//plt::show();

}
