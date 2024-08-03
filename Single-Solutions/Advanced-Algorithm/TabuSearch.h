
#ifndef TABUSEARCH_H
#define TABUSEARCH_H

#include <chrono>

#include "BinPacking.h"
#include "Types.h"
#include "TabuList.h"
#include <tuple>

#include "Neighborhood.h"
using namespace std;

class TabuSearch
{
public:
    TabuSearch(BinPacking& binPacking, 
        int no_improvement_threshold,
        StopType stopType,
        double convergence_threshold,
        int time_limit,
        int tabuSize,
        int tweaksCount);

    double calculate_convergence_threshold(int numItems);
    int calculate_tenure_based_on_quality() const;
    int calculate_tenure_based_on_difference(double difference);
    void algorithm();
    BinPacking getBest_solution();
    vector<double> get_objectives();
    vector<vector<double>> getTweak_probabilities();
    bool aspiration_criteria(bool next_in_tabuList, bool current_in_tabuList, bool is_worse, double next_cost,
                             double best_cost, double epsilon);
    int eval_Count;
    int current_iteration;

    double convergence_threshold;
    vector<int> get_tabuTenures();
    int get_execution_time();
private:
    vector<int> tabu_tenures;
    BinPacking best_solution;
    StopType stopType;
    int no_improvement_count;
    BinPacking first_binPacking;
    Neighborhood neighborhood;
    vector<vector<double>> tweak_probabilities;
    vector<double> objectives;
    int tweaksCount;
    int tabuSize;
    TabuList<int,int,int> tabuList; //contains of item_id - from bin - to bin
    chrono::seconds loop_duration;
    int no_improvement_threshold;
    void addToTabuList(const vector<tuple<int, int, int>>& tuples, int tabu_maxSize);
    bool stopBy_time(std::chrono::high_resolution_clock::time_point start) const;
    bool stopping_condition(std::chrono::high_resolution_clock::time_point start, int count) ;
    bool stopBy_Convergence(int count, std::chrono::high_resolution_clock::time_point start);
    bool stopBy_iteration() const;
    int execution_time;
};

#endif
