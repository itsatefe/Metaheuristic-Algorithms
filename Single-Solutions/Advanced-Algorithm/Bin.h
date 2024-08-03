#ifndef BIN_H
#define BIN_H
#include "Item.h"
#include <vector>

using namespace std;

class Bin {

	public:
		Bin();
		Bin(int id, int capacity);
		void setId(int id);
		void setCapacity(int capacity);
		void setIs_open(bool is_open);
		int getId() const;
		int getCapacity() const;
		bool getIs_open() const;
		void addToBin(Item item);
		vector<Item> getBin_items() const;
		void removeFromBin(const Item& itemToRemove);
		int getUsed_capacity(int total_capacity);
		bool canAddItem(Item  item);
		void setBin_items(vector<Item> bin_items);
	private:
		int id;
		int capacity;
		bool is_open;
		// is this necessary?? except for easiness of saving in an output file?
		vector<Item> bin_items;

};
#endif