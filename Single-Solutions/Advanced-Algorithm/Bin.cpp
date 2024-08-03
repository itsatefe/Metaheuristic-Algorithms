#include "Bin.h"
#include "Item.h"
#include <vector>
using namespace std;

Bin::Bin(){}

Bin::Bin(int id, int capacity) {
	this->id = id;
	this->capacity = capacity;
}
void Bin::setId(int id)
{
	this->id = id;
}
void Bin::setCapacity(int capacity)
{
	this->capacity = capacity;
}
void Bin::setIs_open(bool is_open) 
{
	this->is_open = is_open;
}
int Bin::getId() const
{
	return id;
}
int Bin::getCapacity() const
{
	return capacity;
}
bool Bin::getIs_open() const
{
	return is_open;
}

void Bin::addToBin(Item item) {
	capacity -= item.getWeight();
	bin_items.push_back(item);
}

vector<Item> Bin::getBin_items() const {
	return bin_items;
}

void Bin::removeFromBin(const Item & itemToRemove) {
	auto newEnd = remove_if(bin_items.begin(), bin_items.end(),
		[&itemToRemove](const Item& item) { return item.getId() == itemToRemove.getId(); });
	bin_items.erase(newEnd, bin_items.end());
	capacity += itemToRemove.getWeight();
}

int Bin::getUsed_capacity(int total_capacity)
{
	return total_capacity - capacity;
}
bool Bin::canAddItem(Item  item)
{
	return capacity >= item.getWeight();
}

void Bin::setBin_items(vector<Item> bin_items)
{
	this->bin_items = bin_items;
}
