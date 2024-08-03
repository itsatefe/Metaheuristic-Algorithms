#ifndef ITEM_H
#define ITEM_H
using namespace std;

class Item
{
	public:
		Item();
		Item(int id, int weight);
		void set_weight(int weight);
		void setId(int id);
		void setIs_used(bool is_used);
		int getId() const;
		int getWeight() const;
		bool getIs_used() const;
		int getBin_id() const;
		void setBin_id(int bin_id);
	private:
		int weight;
		int id;
		bool is_used;
		int bin_id;
};
#endif

