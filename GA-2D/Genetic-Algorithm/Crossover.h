#ifndef CROSSOVER_H
#define CROSSOVER_H
#include <vector>
#include "Chromosome.h"

#include "Types.h"
using namespace std;

class Crossover
{
public:
	static vector<Chromosome> swap_two_point(Chromosome parent1, Chromosome parent2);
};
#endif


