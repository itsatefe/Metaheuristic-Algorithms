#include "Item.h"
using namespace std;

Item::Item() {}
Item::Item(int id, int weight)
{
	this->id = id;
	this->weight = weight;
	this->is_used = false;
}

void Item::setId(int id) 
{
	this->id = id;
}
void Item::set_weight(int weight)
{
	this->weight = weight;
}
void Item::setIs_used(bool is_used) 
{
	this->is_used = is_used;
}
bool Item::getIs_used() const 
{
	return is_used;
}

int Item::getBin_id() const
{
	return bin_id;
}

void Item::setBin_id(int bin_id)
{
	this->bin_id = bin_id;
}

int Item::getId() const
{
	return id;
}
int Item::getWeight() const
{
	return weight;
}