#ifndef BIN_H
#define BIN_H

#include <unordered_map>
#include <vector>
#include "Item.h"
#include "Types.h"

using namespace std;

class Bin {
public:
	Bin(int id, int width, int height);
	Bin();
	bool place_rectangle(Item& item);
	bool fits(const Item& item, int x, int y) const;
	int get_used_area() const;
	int get_total_area() const;
	int get_width() const;
	int get_height() const;
	unordered_map<int, Item>& get_items();
	Item find_item_by_value(int item_id);
	Item& find_item_by_ref(int item_id);
	int get_id() const;
	void set_items(const unordered_map<int, Item>& items);
	void add_item(Item& item);
	bool place_item_bin(Item& item);
	void remove_item(int item_id);
	void set_id(int id);
	bool contains(const Item& item) const;
	Overlap exceeds_item(const Item& item) const;
	void set_bin_feasibility(bool feasible);
	int get_unoccupied_area() const;
	void set_unoccupied_area(int unoccupied_area);
	int get_free_area() const;
	bool can_fit(const Item& item) const;
	static Overlap is_overlapping(const Item& item1, const Item& item2);
	bool check_bin_feasibility();
	vector<pair<Item, Item>> get_immediate_overlapped_items();
	bool get_bin_feasibility() const;
	void display_bin();
	bool place_item_feasible_randomly(Item& item) const;

private:
	static void place_item_in_row(Row& row, Item& item);

	int id_;
	int width_;
	int height_;
	unordered_map<int, Item> items;
	bool bin_feasibility;
	vector<Row> rows;
	int current_y_ = 0;
	int unoccupied_area;
	int free_area;
};

#endif