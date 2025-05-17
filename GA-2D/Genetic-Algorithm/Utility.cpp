#include "matplotlibcpp.h"
#include "Utility.h"
#include <any>
#include <filesystem>
#include <fstream>
#include <sstream>
#include <stdexcept>
#include "Bin.h"
#include <nlohmann/json.hpp>
#include <libxl.h>

namespace plt = matplotlibcpp;
namespace fs = filesystem;
using json = nlohmann::json;
using namespace std;

using namespace libxl;

string removeTxtExtension(const string& filename)
{
	string result = filename;
	size_t extensionPos = result.rfind(".ins2D");
	if (extensionPos != string::npos)
	{
		// Ensure the ".ins2D" is at the end of the string
		if (extensionPos + 6 == result.length())
		{
			result.erase(extensionPos);
		}
	}
	return result;
}

INSTANCE_RESULT Utility::read_items(const string& file_path)
{
	ifstream myFile(file_path + ".ins2D");
	if (!myFile.is_open())
	{
		throw runtime_error("Unable to open file: " + file_path);
	}

	ostringstream ss;
	ss << myFile.rdbuf();
	string fileContents = ss.str();
	myFile.close();

	istringstream iss(fileContents);
	string line;

	if (!getline(iss, line))
	{
		throw runtime_error("File format error: missing item count in file: " + file_path);
	}
	int itemCount = stoi(line);

	if (!getline(iss, line))
	{
		throw runtime_error("File format error: missing bin capacity in file: " + file_path);
	}

	int bin_width, bin_height;
	istringstream binStream(line);
	binStream >> bin_width >> bin_height;

	vector<Item> items;
	for (int id = 1; id <= itemCount && getline(iss, line); ++id)
	{
		int item_width, item_height;
		istringstream itemStream(line);
		itemStream >> item_width >> item_height;
		Item item(id, item_width, item_height);
		items.push_back(item);
	}

	return {bin_width, bin_height, items};
}

void Utility::visualize_bins(vector<Bin> bins, const string& folder_path, int i)
{
	constexpr int bins_per_row = 5;
	const int num_bins = bins.size();
	if (num_bins == 0)
	{
		cerr << "No bins to visualize." << '\n';
		return;
	}

	const int bin_capacity_width = bins[0].get_width();
	const int bin_capacity_height = bins[0].get_height();
	const int num_rows = static_cast<int>(ceil(static_cast<double>(num_bins) / bins_per_row));
	plt::figure_size(1500, num_rows * 300);

	const vector<string> colors = {
		"c", "orange", "purple", "g", "m", "r", "y", "b", "brown", "k"
	};

	for (int i = 0; i < num_bins; ++i)
	{
		plt::subplot(num_rows, bins_per_row, i + 1);
		Bin& bin = bins[i];
		auto items_map = bin.get_items();

		int j = 0;
		for (const auto& [id, item] : items_map)
		{
			// Define rectangle corners
			double x = item.x;
			double y = item.y;
			const double w = item.get_width();
			const double h = item.get_height();

			// Select color based on index
			vector<double> xx = {x, x + w, x + w, x};
			vector<double> yy = {y, y, y + h, y + h};
			string color = colors[j % colors.size()];
			plt::fill(xx, yy, {{"color", color}});

			// Draw border for clarity
			plt::plot({x, x + w, x + w, x, x}, {y, y, y + h, y + h, y}, "k-");

			// Add label
			string text = "id: " + to_string(item.get_id()) + "\n" +
				to_string(item.get_width()) + "x" + to_string(item.get_height());
			//plt::text(x + w / 2, y + h / 2, text);

			++j;
		}

		plt::xlim(0, bin_capacity_width);
		plt::ylim(0, bin_capacity_height);
		plt::title(to_string(bin.get_id()));
		plt::xticks(vector<double>{});
		plt::yticks(vector<double>{});
	}

	plt::tight_layout();
	plt::save(folder_path + "/visualization-" + to_string(i) + ".png");
	plt::close();
	// plt::show();
}

void Utility::plot_best_objectives(const vector<double>& best_objectives, const string& file_path)
{
	vector<int> x_best_objectives(best_objectives.size());
	iota(x_best_objectives.begin(), x_best_objectives.end(), 0);
	plt::figure();
	plt::plot(x_best_objectives, best_objectives);
	plt::title("Best Objectives");
	plt::xlabel("Generation");
	plt::ylabel("Objectives");
	plt::save(file_path + "/best_obj.png");
	plt::close();
	//plt::show();
}

void Utility::plot_avg_objectives(const vector<double>& avg_objectives, const string& file_path)
{
	vector<double> x_number_feasible(avg_objectives.size());
	iota(x_number_feasible.begin(), x_number_feasible.end(), 0);
	plt::figure();
	plt::plot(x_number_feasible, avg_objectives, {{"label", "Feasible, Infeasible"}});
	plt::title("Average Objectives");
	plt::xlabel("Generation");
	plt::ylabel("Number");
	plt::legend();
	plt::save(file_path + "/avg_obj.png");
	plt::close();
	// plt::show();
}

void Utility::plot_feasibility(const vector<int>& number_infeasible, const vector<int>& number_feasible,
                               const string& file_path)
{
	vector<int> x_number_infeasible(number_infeasible.size());
	iota(x_number_infeasible.begin(), x_number_infeasible.end(), 0);
	vector<int> x_number_feasible(number_feasible.size());
	iota(x_number_feasible.begin(), x_number_feasible.end(), 0);
	plt::figure();
	plt::plot(x_number_infeasible, number_infeasible, {{"label", "InFeasible"}});
	plt::plot(x_number_feasible, number_feasible, {{"label", "Feasible"}});

	plt::title("Feasible vs InFeasible");
	plt::xlabel("Generation");
	plt::ylabel("Number");
	plt::legend();
	plt::save(file_path + "/Feasibility.png");
	plt::close();
	// plt::show();
}

void Utility::write_tweak_probabilities(const string& file_path, const vector<vector<double>>& tweak_probabilities)
{
	try
	{
		ofstream outputFile(file_path + +"/tweak_probabilities.txt");
		if (!outputFile.is_open())
		{
			throw runtime_error("Error opening file for writing: " + file_path);
		}
		for (const auto& vec : tweak_probabilities)
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

bool Utility::create_directory_if_not_exists(const string& folder_path)
{
	const fs::path dir(folder_path);
	if (!exists(dir))
	{
		return create_directory(dir);
	}
	return true;
}

unordered_map<string, any> Utility::read_config(const string& folder_path)
{
	unordered_map<string, any> configMap;
	ifstream configFile(folder_path);
	if (!configFile.is_open())
	{
		cerr << "Failed to open file: " << folder_path << '\n';
		return configMap;
	}

	json j;
	try
	{
		configFile >> j;
	}
	catch (const json::parse_error& e)
	{
		cerr << "JSON parsing error: " << e.what() << '\n';
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
		} 
		else if (it.value().is_boolean())
		{
			configMap[it.key()] = it.value().get<bool>();
		} // Add more type checks as needed
		else
		{
			cerr << "Unsupported type for key '" << it.key() << "'" << '\n';
		}
	}

	return configMap;
}

vector<string> Utility::read_excel()
{
	Book* book = xlCreateXMLBook();
	vector<string> dataset_names;
	if (book->load(L"solutions.xlsx"))
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

void Utility::write_excel_bins(const vector<int>& bins_size)
{
	Book* book = xlCreateXMLBook();
	if (book->load(L"solutions_new.xlsx"))
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
			book->save(L"solutions_new.xlsx");
		}
	}
	book->release();
}

void Utility::write_excel_time(vector<int> execution_times)
{
	Book* book = xlCreateXMLBook();
	if (book->load(L"solutions_time.xlsx"))
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
			book->save(L"solutions_time.xlsx");
		}
	}
	book->release();
}


vector<int> Utility::read_best_solution()
{
	Book* book = xlCreateXMLBook();
	vector<int> dataset_values;
	if (book->load(L"solutions.xlsx"))
	{
		Sheet* sheet = book->getSheet(0);
		if (sheet)
		{
			for (int i = 1; i < sheet->lastRow(); ++i)
			{
				if (sheet->isFormula(i, 1))
				{
					continue; // Skip formula cells
				}

				int datasetValue = sheet->readNum(i, 2); // Reading integer values from the third column
				dataset_values.push_back(datasetValue);

			}
			book->release();
		}
	}
	return dataset_values;
}
