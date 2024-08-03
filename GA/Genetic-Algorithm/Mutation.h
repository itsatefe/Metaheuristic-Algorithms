#ifndef MUTATION_H
#define MUTATION_H
#include "Chromosome.h"
#include "Bin.h"


enum FunctionID
{
	Feasible_Reinsert,
	Feasible_Between_Swap,
	Item_Overlap,
	Random_Between_Swap,
	Random_Reinsert,
	//Feasible_Move,
	//Empty_Bin
	//Random_Within_Swap,
	//Feasible_Within_Swap,
};

// I think, mutation probability should be high,
// since many of our operations involve in mutation
class Mutation
{
public:
	static constexpr int tweak_numbers = 5;
	static Chromosome item_exceed_removal(Chromosome offspring);
	static Chromosome item_overlap_removal(Chromosome offspring);
	static bool feasible_insert(Item& item, Bin& bin);
	static void randomly_insert(Item& item, Bin& bin);
	static Chromosome random_reinsert_mutation(Chromosome offspring);
	static Chromosome feasible_reinsert_mutation(Chromosome offspring);
	static int select_item(Bin& bin);
	static Chromosome empty_bin_mutation(Chromosome offspring);
	static Chromosome within_swap_mutation(Chromosome offspring);
	static Chromosome random_between_swap_mutation(Chromosome offspring);
	static Chromosome feasible_between_swap_mutation(Chromosome offspring);

	static vector<double> reassign_probabilities();
	static FunctionID select_tweak(vector<double> tweak_probabilities);
	static Chromosome apply_mutation(FunctionID func, Chromosome offspring);
	static unordered_map<int, vector<int>> RD;
	static unordered_map<int, vector<int>> PN;
};

#endif
