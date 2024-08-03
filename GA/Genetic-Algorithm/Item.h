#ifndef ITEM_H
#define ITEM_H

using namespace std;
class Item
{
public:
	Item();
	bool operator<(const Item& other) const;
	Item(int id, int width, int height);
	int get_width() const;
	int get_height() const;
	int get_id() const;
	int get_bin_id() const;
	void set_bin_id(int bin_id);
	void set_xy(int x, int y);
	int get_area() const;
	int x, y;
	void display_item() const;

private:
	int width_;
	int height_;
	int id;
	int bin_id_;
};
#endif
