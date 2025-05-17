#include "Bin.h"
#include <iostream>
#include <algorithm>
#include "IntervalTree.h"
#include "RectanglePlacement.h"

using namespace  RectanglePlacement;
Bin::Bin(int id, int width, int height)
{
	this->id_ = id;
	this->width_ = width;
	this->height_ = height;
	this->unoccupied_area = height_ * width_; // approximation for infeasible solutions
	this->free_area = height_ * width_; // helpful for feasible solutions
}

Bin::Bin()
= default;


//brute force
bool Bin::place_rectangle(Item& item)
{
	if (!can_fit(item)) return false;
	for (int y = 0; y <= height_ - item.get_height(); ++y)
	{
		for (int x = 0; x <= width_ - item.get_width(); ++x)
		{
			if (fits(item, x, y))
			{
				item.x = x;
				item.y = y;
				add_item(item);
				return true;
			}
		}
	}
	return false;
}

bool Bin::fits(const Item& item, int x, int y) const
{
	const int item_width = item.get_width();
	const int item_height = item.get_height();

	// Check if item is out of bounds
	if (x + item_width > width_ || y + item_height > height_)
	{
		return false;
	}

	// Check if the item overlaps with existing items
	for (const auto& [id, placed_item] : items)
	{
		if (x < placed_item.x + placed_item.get_width() &&
			x + item_width > placed_item.x &&
			y < placed_item.y + placed_item.get_height() &&
			y + item_height > placed_item.y)
		{
			return false;
		}
	}
	return true;
}

int Bin::get_used_area() const
{
	int used_area = 0;
	for (const auto& [id, item] : items)
	{
		used_area += item.get_width() * item.get_height();
	}
	return used_area;
}

Item Bin::find_item_by_value(int item_id)
{
	auto item_it = items.find(item_id);
	if (item_it != items.end())
	{
		return item_it->second;
	}

	cerr << "Error: Item with ID " << item_id << " not found in bin." << '\n';
	throw runtime_error("find item in the bin function: Item not found");

}
Item& Bin::find_item_by_ref(int item_id)
{
	auto item_it = items.find(item_id);
	if (item_it != items.end())
	{
		return item_it->second;
	}

	cerr << "Error: Item with ID " << item_id << " not found in bin." << '\n';
	throw runtime_error("find item in the bin function: Item not found");

}

int Bin::get_id() const
{
	return id_;
}

void Bin::set_items(const unordered_map<int, Item>& new_items)
{
	this->items = new_items;
	this->free_area = get_total_area() - get_used_area();
}

void Bin::add_item(Item& item)
{
	item.set_bin_id(id_);
	items[item.get_id()] = item;
	//items.insert({ item.get_id(), item });
	free_area -= item.get_area();
}

bool Bin::place_item_bin(Item& item)
{
	if (!rows.empty() && rows.back().width_used + item.get_width() <= width_)
	{
		place_item_in_row(rows.back(), item);
	}
	else
	{
		if (current_y_ + item.get_height() > height_)
		{
			return false;
		}
		rows.emplace_back(current_y_);
		place_item_in_row(rows.back(), item);
		current_y_ += item.get_height();
	}
	return true;
}

void Bin::place_item_in_row(Row& row, Item& item)
{
	item.set_xy(row.width_used, row.y_position);
	row.items.push_back(item);
	row.width_used += item.get_width();
}

bool Bin::place_item_feasible_randomly(Item& item) const
{
	if (!can_fit(item)) return false;
	auto unoccupied_areas = detect_unoccupied_areas(items, width_, height_);
	auto [placed_rect, unoccupied_bin_area] = RectanglePlacement::place_rectangle(item.get_width(), item.get_height(), unoccupied_areas);
	if (get<0>(placed_rect) != -1)
	{
		int x = get<0>(placed_rect);
		int y = get<1>(placed_rect);
		if (x + item.get_width() > width_ || x < 0 || y + item.get_height() > height_ || y < 0)
			return false;
		item.set_xy(x, y);
		return true;
	}
	return false;
}

void Bin::remove_item(int item_id)
{
	Item item = find_item_by_value(item_id);
	items.erase(item_id);
	free_area += item.get_area();
}

Overlap Bin::exceeds_item(const Item& item) const
{
	bool right = item.x + item.get_width() > width_;
	bool top = item.y + item.get_height() > height_;
	if (top && right) return { true, BOTH };
	if (top) return { true, TOP };
	if (right) return { true, RIGHT };
	return { false, NONE };
}

void Bin::set_bin_feasibility(bool feasible)
{
	bin_feasibility = feasible;
}

int Bin::get_unoccupied_area() const
{
	return unoccupied_area;
}

void Bin::set_unoccupied_area(int unoccupied_area_value)
{
	this->unoccupied_area = unoccupied_area_value;
}

Overlap Bin::is_overlapping(const Item& item1, const Item& item2)
{
	// check if these two items have overlapped or not
	bool horizontal = !((item1.x + item1.get_width() <= item2.x) ||
		(item2.x + item2.get_width() <= item1.x));
	bool vertical = !((item2.y + item2.get_height() <= item1.y) ||
		(item1.y + item1.get_height() <= item2.y));

	if (horizontal && vertical) return { true, BOTH };
	if (horizontal) return { true, HORIZONTAL };
	if (vertical) return { true, VERTICAL };
	return { false, NONE };
}

bool Bin::check_bin_feasibility()
{
	vector<Event> events;
	bin_feasibility = true;
	for (auto& [id, rect] : items)
	{
		events.push_back({ rect.x, true, &rect });
		events.push_back({ rect.x + rect.get_width(), false, &rect });
	}

	sort(events.begin(), events.end());
	IntervalTree activeIntervals;

	for (const auto& event : events)
	{
		Interval interval = { event.rect->y, event.rect->y + event.rect->get_height(), event.rect };

		if (event.isLeft)
		{
			auto [overlapped, overlappingRect] = activeIntervals.overlapSearch(interval);
			if (overlapped)
			{
				if (event.rect == nullptr)
					cout << "event rect is null: " << '\n';
				if (overlappingRect == nullptr)
					cout << "overlappingRect is null: " << '\n';
				bin_feasibility = false;
				return bin_feasibility;
			}
			activeIntervals.insert(interval);
		}
		else
		{
			activeIntervals.remove(interval);
		}
	}
	return bin_feasibility;
}

vector<pair<Item, Item>> Bin::get_immediate_overlapped_items()
{
	vector<pair<Item, Item>> immediate_overlapped_items;
	vector<Event> events;
	bin_feasibility = true;
	for (auto& [id, rect] : items)
	{
		events.push_back({ rect.x, true, &rect });
		events.push_back({ rect.x + rect.get_width(), false, &rect });
	}

	sort(events.begin(), events.end());
	IntervalTree activeIntervals;

	for (const auto& event : events)
	{
		Interval interval = { event.rect->y, event.rect->y + event.rect->get_height(), event.rect };

		if (event.isLeft)
		{
			auto [overlapped, overlappingRect] = activeIntervals.overlapSearch(interval);
			if (overlapped)
			{
				if (event.rect == nullptr)
					cout << "event rect is null: " << '\n';
				if (overlappingRect == nullptr)
					cout << "overlappingRect is null: " << '\n';
				immediate_overlapped_items.emplace_back(*event.rect, *overlappingRect);
				bin_feasibility = false;
			}
			activeIntervals.insert(interval);
		}
		else
		{
			activeIntervals.remove(interval);
		}
	}
	return immediate_overlapped_items;
}

bool Bin::get_bin_feasibility() const
{
	return bin_feasibility;
}

void Bin::display_bin()
{
	cout << "Bin " << id_ << ": ";
	for (const auto& [id, item] : get_items())
	{
		item.display_item();
		cout << ", ";
	}
	cout << '\n';
}

void Bin::set_id(int id)
{
	this->id_ = id;
}

bool Bin::contains(const Item& item) const
{
	return items.contains(item.get_id());
}

int Bin::get_free_area() const
{
	return free_area;
}

bool Bin::can_fit(const Item& item) const
{
	if (get_bin_feasibility())
	{
		if (get_free_area() < item.get_area())
		{
			return false;
		}
	}
	else if (get_unoccupied_area() < item.get_area())
	{
		return false;
	}
	return true;
}

int Bin::get_total_area() const
{
	return width_ * height_;
}

int Bin::get_width() const
{
	return width_;
}

int Bin::get_height() const
{
	return height_;
}

unordered_map<int, Item>& Bin::get_items()
{
	return items;
}
