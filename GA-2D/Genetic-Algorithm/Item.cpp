#include "Item.h"
#include <iostream>

Item::Item()
{
}

bool Item::operator<(const Item& other) const
{
	return get_area() < other.get_area();
}

Item::Item(int id, int width, int height)
	: x(0), y(0), width_(width), height_(height), id(id), bin_id_(-1)
{
}

int Item::get_width() const
{
	return width_;
}

int Item::get_height() const
{
	return height_;
}

int Item::get_id() const
{
	return id;
}

int Item::get_bin_id() const
{
	return bin_id_;
}

void Item::set_bin_id(int bin_id)
{
	bin_id_ = bin_id;
}

void Item::set_xy(int x, int y)
{
	this->x = x;
	this->y = y;
}

int Item::get_area() const
{
	return width_ * height_;
}

//void Item::display_item() const {
//	cout << "Item ID: " << id
//		<< ", Width: " << get_width()
//		<< ", Height: " << get_height()
//		<< ", Bin ID: " << bin_id_
//		<< ", Position: (" << x << ", " << y << ")"
//		<< '\n';
//}

void Item::display_item() const
{
	cout << id << " - " << '(' << x << "," << y << ')';
}
