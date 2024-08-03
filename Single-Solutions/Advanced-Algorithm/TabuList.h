#ifndef TABULIST_H
#define TABULIST_H

#include <unordered_map>
#include <queue>
#include <list>
#include <tuple>
#include <iostream>
#include <optional>

template <typename KeyType, typename FromType, typename ToType>
class TabuList
{
private:
    struct Entry {
        KeyType key;
        std::tuple<FromType, ToType> change;
    };

    std::unordered_map<KeyType, std::queue<std::tuple<FromType, ToType>>> map;
    std::list<Entry> orderList;
    size_t maxTabuSize;

public:
    list<Entry> get_orderList()
    {
        return orderList;
    }
    TabuList(size_t max_size) : maxTabuSize(max_size) {}

    void setMaxTabuSize(size_t max_size) {
        maxTabuSize = max_size;
        while (orderList.size() > maxTabuSize) {
            pop(); 
        }
    }

    void put(const KeyType& key, const FromType& from, const ToType& to) {
        if (orderList.size() == maxTabuSize) {
            pop(); 
        }
        map[key].push(std::make_tuple(from, to));
        orderList.push_back({ key, std::make_tuple(from, to) });
    }

    std::optional<std::tuple<KeyType, FromType, ToType>> pop() {
        if (orderList.empty()) {
            return {};
        }

        auto oldest = orderList.front();
        orderList.pop_front();

        auto& queue = map[oldest.key];
        queue.pop();

        if (queue.empty()) {
            map.erase(oldest.key);
        }

        return std::make_optional(std::make_tuple(oldest.key, std::get<0>(oldest.change), std::get<1>(oldest.change)));
    }

    std::vector<std::tuple<FromType, ToType>> get(const KeyType& key) {
        std::vector<std::tuple<FromType, ToType>> changes;
        auto it = map.find(key);
        if (it != map.end()) {
            std::queue<std::tuple<FromType, ToType>> tempQueue = it->second;
            while (!tempQueue.empty()) {
                changes.push_back(tempQueue.front());
                tempQueue.pop();
            }
        }
        return changes;
    }

    void display() {
        for (const auto& pair : map) {
            const KeyType& key = pair.first;
            const std::queue<std::tuple<FromType, ToType>>& changesQueue = pair.second;
            std::queue<std::tuple<FromType, ToType>> tempQueue = changesQueue;

            std::cout << "Item ID: " << key << '\n';
            while (!tempQueue.empty()) {
                std::tuple<FromType, ToType> change = tempQueue.front();
                tempQueue.pop();
                std::cout << "  Change from: " << std::get<0>(change)
                    << " to: " << std::get<1>(change) << '\n';
            }
        }
        std::cout << "Total tabu entries: " << size() << '\n';
        std::cout << "-------------------------------------" << '\n';
    }

    size_t size() const {
        return orderList.size();
    }



    bool is_tabu(const std::vector<std::tuple<KeyType, FromType, ToType>>& tuples) {
        for (const auto& t : tuples) {
            KeyType item_id = std::get<0>(t);
            FromType from_bin = std::get<1>(t);
            ToType to_bin = std::get<2>(t);

            auto changes = get(item_id);

            bool found = std::any_of(changes.begin(), changes.end(),
                [from_bin, to_bin](const std::tuple<FromType, ToType>& change) {
                    return std::get<0>(change) == to_bin;
                });
            if (!found) return false;
        }
        return true;
    }
};

#endif
