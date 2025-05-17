#ifndef NEIGHBORHOOD_H
#define NEIGHBORHOOD_H
#include "Chromosome.h"
#include "Bin.h"


enum FunctionID
{
	Feasible_Reinsert,
	Feasible_Between_Swap,
	//Item_Overlap,

	//Feasible_Move,
	Empty_Bin
	//Feasible_Within_Swap,
};

class Neighborhood
{
public:
	static constexpr int tweak_numbers = 3;
	static bool feasible_insert(Item& item, Bin& bin);
	static Chromosome feasible_reinsert_tweak(Chromosome offspring);
	static int select_item(Bin& bin);
	static Chromosome empty_bin_tweak(Chromosome offspring);
	static Chromosome within_swap_tweak(Chromosome offspring);
	static Chromosome feasible_between_swap_tweak(Chromosome offspring);
	static Chromosome item_overlap_removal(Chromosome offspring);
	static vector<double> reassign_probabilities();
	static FunctionID select_tweak(vector<double> tweak_probabilities);
	static Chromosome apply_tweak(FunctionID func, Chromosome offspring);
	static unordered_map<int, vector<int>> RD;
	static unordered_map<int, vector<int>> PN;
};

#endif
