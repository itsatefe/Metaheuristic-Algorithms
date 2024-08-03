#ifndef INTERVALTREE_H
#define INTERVALTREE_H

#include <algorithm>
#include <climits>

#include <memory>
#include <vector>


struct Interval {
    int low, high;
    const Item* rect;

    bool operator<(const Interval& other) const {
        return low < other.low;
    }
};

class IntervalTree {
private:
    struct Node {
        Interval interval;
        int max;
        std::unique_ptr<Node> left;
        std::unique_ptr<Node> right;

        Node(const Interval& i) : interval(i), max(i.high), left(nullptr), right(nullptr) {}
    };

    std::unique_ptr<Node> root;

    std::unique_ptr<Node> insert(std::unique_ptr<Node> node, const Interval& i) {
        if (!node) return std::make_unique<Node>(i);

        int l = node->interval.low;

        if (i.low < l)
            node->left = insert(std::move(node->left), i);
        else
            node->right = insert(std::move(node->right), i);

        if (node->max < i.high)
            node->max = i.high;

        return node;
    }

    std::unique_ptr<Node> deleteNode(std::unique_ptr<Node> root, const Interval& i) {
        if (!root) return nullptr;

        if (i.low < root->interval.low)
            root->left = deleteNode(std::move(root->left), i);
        else if (i.low > root->interval.low)
            root->right = deleteNode(std::move(root->right), i);
        else {
            if (root->left == nullptr) {
                return std::move(root->right);
            }
            else if (root->right == nullptr) {
                return std::move(root->left);
            }

            Node* temp = minValueNode(root->right.get());
            root->interval = temp->interval;
            root->right = deleteNode(std::move(root->right), temp->interval);
        }

        if (root) root->max = std::max(root->interval.high, std::max(getMax(root->left.get()), getMax(root->right.get())));
        return root;
    }

    Node* minValueNode(Node* node) {
        Node* current = node;
        while (current && current->left != nullptr)
            current = current->left.get();

        return current;
    }

    bool doOverlap(const Interval& i1, const Interval& i2) const {
        return i1.low < i2.high && i2.low < i1.high;
    }

    std::pair<bool, const Item*> overlapSearch(Node* node, const Interval& i) const {
        if (!node) return { false, nullptr };

        if (doOverlap(node->interval, i))
            return { true, node->interval.rect };

        if (node->left != nullptr && node->left->max > i.low)
            return overlapSearch(node->left.get(), i);

        return overlapSearch(node->right.get(), i);
    }

    int getMax(Node* node) const {
        return node ? node->max : INT_MIN;
    }

    void destroy(Node* node) {
        if (node) {
            destroy(node->left.get());
            destroy(node->right.get());
        }
    }

    void getIntervals(Node* node, std::vector<std::pair<int, int>>& intervals) const {
        if (node) {
            intervals.push_back({ node->interval.low, node->interval.high });
            getIntervals(node->left.get(), intervals);
            getIntervals(node->right.get(), intervals);
        }
    }

public:
    IntervalTree() : root(nullptr) {}

    ~IntervalTree() = default;

    void insert(const Interval& i) {
        root = insert(std::move(root), i);
    }

    void remove(const Interval& i) {
        root = deleteNode(std::move(root), i);
    }

    std::pair<bool, const Item*> overlapSearch(const Interval& i) const {
        return overlapSearch(root.get(), i);
    }

    std::vector<std::pair<int, int>> get_intervals() const {
        std::vector<std::pair<int, int>> intervals;
        getIntervals(root.get(), intervals);
        return intervals;
    }
};

#endif
