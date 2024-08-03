#ifndef NEIGHBORHOOD_H
#define NEIGHBORHOOD_H
#include <vector>
#include "BinPacking.h"
#include <functional>

using namespace std;


struct Result
{
	vector<tuple<int, int, int>> changes;
	BinPacking binPacking;
};

enum FunctionID
{
	//SingleItemMove,
	Swap,
	//MergeBins,
	EmptyBin,
	//SplitBin,
	//ItemReinsertion
};

class Neighborhood
{
private:
	static Result single_item_move(BinPacking binPacking);
	static Result swap_item(BinPacking binPacking);
	static Result merge_bins(BinPacking binPacking);
	static Result split_bin(BinPacking binPacking);
	static BinPacking multiple_item_move(BinPacking binPacking);
	vector<double> tweak_probabilities;
	static Result item_reinsertion(BinPacking binPacking);
	static Result empty_bin(BinPacking binPacking);


public:
	void setTweak_probabilities(const vector<double>& tweak_probabilities);
	vector<double> getTweak_probabilities();
	vector<double> reassign_probabilities();
	Neighborhood();
	const int tweak_numbers = 2;
	FunctionID select_tweak();
	static Result call_tweak(FunctionID func, const BinPacking& binPacking);
	unordered_map<int, vector<int>> RD;
	unordered_map<int, vector<int>> PN;
};

#endif
