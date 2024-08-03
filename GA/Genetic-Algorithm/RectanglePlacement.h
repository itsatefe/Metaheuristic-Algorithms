#ifndef RECTANGLE_PLACEMENT_H
#define RECTANGLE_PLACEMENT_H

#include <vector>
#include <tuple>
#include <algorithm>
#include <map>
#include <unordered_map>
#include "IntervalTree.h"
#include "Item.h"
#include <random>
namespace RectanglePlacement
{
	inline int unoccupied_bin_area = 0;

	inline std::vector<std::pair<int, int>> calculate_unoccupied_y(IntervalTree& tree, int container_height) {
		map<int, int> yCounts;
		auto intervals = tree.get_intervals();

		// Update counts for interval starts and ends
		for (const auto& interval : intervals) {
			yCounts[interval.first]++;
			yCounts[interval.second]--;
		}

		// Calculate unoccupied areas
		std::vector<std::pair<int, int>> unoccupied;
		int currentY = 0, activeIntervals = 0;
		for (const auto& yCount : yCounts) {
			if (activeIntervals == 0 && yCount.first > currentY) {
				unoccupied.push_back({ currentY, yCount.first });
			}
			activeIntervals += yCount.second;
			currentY = yCount.first;
		}

		if (currentY < container_height) {
			unoccupied.push_back({ currentY, container_height });
		}

		return unoccupied;
	}


	// Function to detect unoccupied areas in a 2D container
	inline std::vector<std::tuple<int, int, int, int>> detect_unoccupied_areas(
		const std::unordered_map<int, Item>& rectangles, int container_width, int container_height)
	{
		std::vector<Event> events;
		IntervalTree active_intervals;

		// Create events for each rectangle
		for (const auto& pair : rectangles)
		{
			const Item& rect = pair.second;
			events.push_back({ rect.x, true, &rect });
			events.push_back({ rect.x + rect.get_width(), false, &rect });
		}

		// Sort events
		std::sort(events.begin(), events.end());

		// Sweep line processing
		int last_x = 0;
		std::vector<std::tuple<int, int, int, int>> unoccupied_spaces;
		for (const auto& event : events)
		{
			int x = event.x;
			if (x != last_x)
			{
				auto unoccupied_y = calculate_unoccupied_y(active_intervals, container_height);
				for (const auto& uy : unoccupied_y)
				{
					unoccupied_spaces.push_back({ last_x, x, uy.first, uy.second });
				}
				last_x = x;
			}

			if (event.isLeft)
				active_intervals.insert({ event.rect->y, event.rect->y + event.rect->get_height(), event.rect });
			else
				active_intervals.remove({ event.rect->y, event.rect->y + event.rect->get_height(), event.rect });
		}

		// Final sweep to the end of the container width
		auto unoccupied_y = calculate_unoccupied_y(active_intervals, container_height);
		for (const auto& uy : unoccupied_y)
		{
			unoccupied_spaces.push_back({ last_x, container_width, uy.first, uy.second });
		}

		return unoccupied_spaces;
	}

	inline int calculate_total_area(const std::vector<std::tuple<int, int, int, int>>& merged_spaces)
	{
		int total_area = 0;

		for (const auto& space : merged_spaces)
		{
			int width = std::get<1>(space) - std::get<0>(space);
			int height = std::get<3>(space) - std::get<2>(space);
			total_area += width * height;
		}

		return total_area;
	}

	// Function to merge horizontally aligned unoccupied spaces
	inline std::vector<std::tuple<int, int, int, int>> merge_spaces(
		std::vector<std::tuple<int, int, int, int>> unoccupied_spaces)
	{
		std::sort(unoccupied_spaces.begin(), unoccupied_spaces.end());
		std::vector<std::tuple<int, int, int, int>> merged_spaces;

		for (const auto& space : unoccupied_spaces)
		{
			if (merged_spaces.empty())
			{
				merged_spaces.push_back(space);
			}
			else
			{
				auto& last = merged_spaces.back();
				if (std::get<1>(last) == std::get<0>(space) && std::get<2>(last) == std::get<2>(space) && std::get<
					3>(last) == std::get<3>(space))
				{
					std::get<1>(last) = std::get<1>(space);
				}
				else
				{
					merged_spaces.push_back(space);
				}
			}
		}
		return merged_spaces;
	}


	// Function to place a new rectangle in the first suitable unoccupied space
	inline std::pair<std::tuple<int, int, int, int>, int> place_rectangle(
		int w, int h, std::vector<std::tuple<int, int, int, int>> unoccupied_spaces)
	{
		auto merged_spaces = merge_spaces(unoccupied_spaces);
		
		unoccupied_bin_area = calculate_total_area(merged_spaces);
		if (unoccupied_bin_area < w * h) return { {-1, -1, -1, -1}, unoccupied_bin_area };


		for (auto it = merged_spaces.begin(); it != merged_spaces.end(); ++it)
		{
			int x1, x2, y1, y2;
			std::tie(x1, x2, y1, y2) = *it;

			if (w <= (x2 - x1) && h <= (y2 - y1))
			{
				std::tuple<int, int, int, int> new_rect_position = { x1, y1, x1 + w, y1 + h };

				std::vector<std::tuple<int, int, int, int>> new_spaces(merged_spaces.begin(), it);
				new_spaces.insert(new_spaces.end(), it + 1, merged_spaces.end());
				unoccupied_bin_area -= w * h;
				if (y1 + h < y2)
				{
					new_spaces.push_back({ x1, x2, y1 + h, y2 });
				}
				if (x1 + w < x2)
				{
					new_spaces.push_back({ x1 + w, x2, y1, y2 });
				}

				return { new_rect_position, unoccupied_bin_area };
			}
		}

		return { {-1, -1, -1, -1}, unoccupied_bin_area }; // If no suitable space found
	}
};

#endif 
