#ifndef TYPES_H
#define TYPES_H
#include "../../Genetic-Algorithm/Chromosome.h"

enum survivalType
{
	generational,
	elitism
};
enum StopType {
	timeLimit,
	iteration,
	convergence,
	evalCount
};

struct Offsprings
{
	Chromosome offspring1;
	Chromosome offspring2;
};


#endif
